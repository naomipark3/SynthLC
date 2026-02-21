// =============================================================================
// Formal environment for Ibex RISC-V core (SynthLC / RTL2MuPATH harness)
//
// Goal:
// - IF stage is black-boxed => its outputs are free variables.
// - Constrain frontend-related error/interrupt/debug inputs to simplify IUV analysis.
// - Symbolic (pc0, i0) tracked at ID stage.
// - Multi-cycle safe: do NOT assume pc_id stays pc0 during mul/div/lsu.
// =============================================================================

`define INTRA_TRANSMITTER

// =============================================================================
// Processor in operation (no reset during verification)
// =============================================================================
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// =============================================================================
// Constrain black-boxed frontend / external inputs (keep core "quiet")
// =============================================================================
NO_FETCH_ERR: assume property (@(posedge clk_i) core_i.instr_fetch_err == 1'b0);
NO_INSTR_ERR: assume property (@(posedge clk_i) core_i.instr_err_i     == 1'b0);
NO_DATA_ERR:  assume property (@(posedge clk_i) core_i.data_err_i      == 1'b0);

// Disable interrupts and debug during IUV analysis
NO_IRQ_SW:    assume property (@(posedge clk_i) core_i.irq_software_i  == 1'b0);
NO_IRQ_TIM:   assume property (@(posedge clk_i) core_i.irq_timer_i     == 1'b0);
NO_IRQ_EXT:   assume property (@(posedge clk_i) core_i.irq_external_i  == 1'b0);
NO_IRQ_FAST:  assume property (@(posedge clk_i) core_i.irq_fast_i      == 15'b0);
NO_IRQ_NMI:   assume property (@(posedge clk_i) core_i.irq_nm_i        == 1'b0);
NO_DEBUG:     assume property (@(posedge clk_i) core_i.debug_req_i     == 1'b0);

// =============================================================================
// Symbolic instruction of interest: (pc0, i0)
// =============================================================================
wire [31:0] pc0;
pc0_const:   assume property (@(posedge clk_i) $stable(pc0));
pc0_nozero:  assume property (@(posedge clk_i) pc0 != 32'h0);

wire [31:0] i0;
i0_const:    assume property (@(posedge clk_i) $stable(i0));

// =============================================================================
// IUV (Instruction under verification) definition at ID stage (Ibex)
// =============================================================================
//
// NOTE: You MUST align these signal names to your Ibex integration.
// Common patterns:
//   - core_i.instr_valid_id  : ID-stage instruction valid
//   - core_i.pc_id           : ID-stage PC
//   - core_i.instr_rdata_id  : ID-stage raw instruction bits
//
// IUV Binding
wire iuv_in_id = (core_i.instr_valid_id && (core_i.pc_id == pc0));

// Associate instruction bits with i0 when IUV is in ID
pc0_i0_assoc: assume property (@(posedge clk_i)
  iuv_in_id |-> (core_i.instr_rdata_id == i0)
);

// =============================================================================
// "Issue once" bookkeeping (do not over-restrict the pipeline)
// =============================================================================
logic instn_begun;
wire  instn_begin = iuv_in_id && !instn_begun;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) instn_begun <= 1'b0;
  else if (instn_begin) instn_begun <= 1'b1;
end

// After we've seen IUV once, we require it not to re-appear in ID again.
// This is a light constraint compared to banning all fetches.
ISSUE_ONCE: assume property (@(posedge clk_i)
  instn_begin |-> !iuv_in_id
);


// =============================================================================
// Liveness (eventual issue)
// =============================================================================
reg first;
initial first = 1'b1;
always @(posedge clk_i) first <= 1'b0;

EVENTUAL_ISSUE: assume property (@(posedge clk_i)
  first |-> s_eventually(instn_begin)
);

wire [31:0] pc_id = core_i.if_stage_i.pc_id_o; wire id_valid = core_i.id_stage_i.instr_executing; wire id_fsm = core_i.id_stage_i.id_fsm_q; // 0 = FIRST_CYCLE, 1 = MULTI_CYCLE

wire [31:0] wb_pc    = core_i.wb_stage_i.g_writeback_stage.wb_pc_q; // If JG complains about the generate block path, fall back to the output port for PC
wire        wb_valid = core_i.wb_stage_i.g_writeback_stage.wb_valid_q;

logic [31:0] lsu_owner_pc;
logic        lsu_owner_v;
wire [2:0]   ls_fsm = core_i.load_store_unit_i.ls_fsm_cs;

wire lsu_start = core_i.load_store_unit_i.lsu_req_i && 
                 (ls_fsm == 3'd0) && !lsu_owner_v;  // IDLE == 0
wire lsu_end   = lsu_owner_v && core_i.lsu_resp_valid;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    lsu_owner_pc <= '0;
    lsu_owner_v  <= 1'b0;
  end else begin
    if (lsu_end) lsu_owner_v <= 1'b0;
    if (lsu_start) begin
      lsu_owner_pc <= pc_id;
      lsu_owner_v  <= 1'b1;
    end
  end
end

logic [31:0] mul_owner_pc;
logic        mul_owner_v;

logic [31:0] div_owner_pc;
logic        div_owner_v;

// shared signals
wire valid = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.valid_o;

wire [2:0] div_state =
core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q;

wire [1:0] mult_state =
core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q;

wire mult_en = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i;
wire div_en = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i;

// start events (your current definition)
// wire mult_start = mult_en && (mult_state == 2'd0); // ALBL
wire mult_start = mult_en && (mult_state == 2'd0) && !mul_owner_v;
//wire div_start = div_en && (div_state == 3'd0); // MD_IDLE
wire div_start = div_en && (div_state == 3'd0) && !div_owner_v;

// done events (recommended: gate done by which op is "owned")
wire mul_done = mul_owner_v && valid;
wire div_done = div_owner_v && valid;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    mul_owner_pc <= '0;
    mul_owner_v  <= 1'b0;
    div_owner_pc <= '0;
    div_owner_v  <= 1'b0;
  end else begin

    // clear first (finish)
    if (mul_done) mul_owner_v <= 1'b0;
    if (div_done) div_owner_v <= 1'b0;

    // capture new owner
    if (mult_start && !div_start) begin
      mul_owner_pc <= pc_id;
      mul_owner_v  <= 1'b1;
    end

    if (div_start && !mult_start) begin
      div_owner_pc <= pc_id;
      div_owner_v  <= 1'b1;
    end

  end
end 

