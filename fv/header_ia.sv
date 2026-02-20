
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
  instn_begun |-> !iuv_in_id
);

// =============================================================================
// Ibex stage PCs
// =============================================================================
wire [31:0] pc_if = core_i.pc_if;   // IF stage fetch PC
wire [31:0] pc_id = core_i.pc_id;   // ID stage decode PC
wire [31:0] pc_wb = core_i.pc_wb;   // WB stage PC (if present)


// =============================================================================
// Liveness (eventual issue)
// =============================================================================
reg first;
initial first = 1'b1;
always @(posedge clk_i) first <= 1'b0;

EVENTUAL_ISSUE: assume property (@(posedge clk_i)
  first |-> s_eventually(instn_begin)
);

// =============================================================================
// Optional: IF/ID "hold contract" (ONLY if you have an explicit stall/ready)
// =============================================================================
//
// If your bbox IF->ID interface can stall, and you have a "ready/accept" signal,
// you can constrain stability when valid && !ready.
// Otherwise, leave this OFF to avoid wrong assumptions.
//
// Example (YOU MUST fix signal names):
//
// wire id_accept = core_i.id_accept_i; // e.g., "id_ready" / "if_id_ready" / etc.
// IF_ID_HOLD: assume property (@(posedge clk_i)
//   (core_i.instr_valid_id && !id_accept) |=>
//     ($past(core_i.instr_valid_id) == core_i.instr_valid_id) &&
//     ($past(core_i.pc_id)          == core_i.pc_id)          &&
//     ($past(core_i.instr_rdata_id) == core_i.instr_rdata_id)
// );

// =============================================================================
// Optional: Retirement / completion (multi-cycle safe versions)
// =============================================================================

// With WritebackStage=0, retirement happens effectively at ID/EX boundary,
// and pc_id should correspond to the retiring instruction (IF/ID is stalled until done).
wire instn_retire = core_i.wb_stage_i.perf_instr_ret_wb_o && (core_i.pc_id == pc0);

// EVENTUAL_RETIRE: assume property (@(posedge clk_i)
//  instn_begun |-> s_eventually(instn_retire)
//);

//
// =========================================================================
// Owner latch
// =========================================================================
logic [31:0] md_owner_pc;
logic        md_owner_v;
logic [31:0] lsu_owner_pc;
logic        lsu_owner_v;

// =============================================================================
// MULDIV owner-PC latch (multi-cycle safe, verification-only)
// =============================================================================

// ---- MULDIV signals (hierarchical paths; adjust if your instance names differ)
wire md_ready = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.multdiv_ready_id_i;
wire md_valid = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.valid_o;

// Divider state (MD_IDLE is 3'd0)
wire [2:0] div_state =
  core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q;

// Fast multiplier FSM state (ALBL is 2'd0) — this exists under gen_mult_fast
wire [1:0] mult_state =
  core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q;

// Enables (ports, stable)
wire mult_en = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i;
wire div_en  = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i;

// “Start/accept” events: enable asserted, ID is ready to progress, and FSM at start state
wire mult_start = mult_en && md_ready && (mult_state == 2'd0); // ALBL
wire div_start  = div_en  && md_ready && (div_state  == 3'd0); // MD_IDLE



always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    md_owner_pc <= '0;
    md_owner_v  <= 1'b0;
  end else begin
    // Capture owner PC when an operation is accepted
    if (mult_start || div_start) begin
      md_owner_pc <= pc_id;
      md_owner_v  <= 1'b1;
    end

    // Clear owner when result handshakes back (valid held until ready)
    if (md_owner_v && md_valid && md_ready) begin
      md_owner_v <= 1'b0;
    end
  end
end

// Convenience predicate: "MULDIV activity belongs to the IUV at pc0"
wire md_is_owner_pc0 = md_owner_v && (md_owner_pc == pc0);

// =============================================================================
// LSU owner-PC latch (precise, derived from ibex_load_store_unit semantics)
// =============================================================================


// LSU FSM state and request from ID/EX into LSU
wire [2:0] lsu_state = core_i.load_store_unit_i.ls_fsm_cs;
wire       lsu_req   = core_i.load_store_unit_i.lsu_req_i;

// LSU response-valid (exact transaction completion point)
wire       lsu_resp_valid = core_i.load_store_unit_i.lsu_resp_valid_o;

// Start: first cycle a request is presented while LSU is idle.
// (Matches design intent: IDLE + lsu_req_i kicks off request.)
wire lsu_start = lsu_req && (lsu_state == 3'd0) && !lsu_owner_v;

// Done: LSU reports response valid (covers normal rvalid and PMP error path).
wire lsu_done  = lsu_owner_v && lsu_resp_valid;

// Latch owner PC
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    lsu_owner_pc <= '0;
    lsu_owner_v  <= 1'b0;
  end else begin
    // If a transaction completes and a new one starts same cycle, we want to capture the new one.
    if (lsu_done) begin
      lsu_owner_v <= 1'b0;
    end
    if (lsu_start) begin
      lsu_owner_pc <= pc_id;
      lsu_owner_v  <= 1'b1;
    end
  end
end

wire lsu_is_owner_pc0 = lsu_owner_v && (lsu_owner_pc == pc0);

// =============================================================================
// ## Performing location annotation
// ============================================================================= 


wire id_ctrl_s1 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd1) && 
	 1'b1; 
wire id_ctrl_s2 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd2) && 
	 1'b1; 
wire id_ctrl_s3 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd3) && 
	 1'b1; 
wire id_ctrl_s4 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd4) && 
	 1'b1; 
wire id_ctrl_s5 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd5) && 
	 1'b1; 
wire id_ctrl_s6 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.id_stage_i.controller_i.ctrl_fsm_cs == 4'd6) && 
	 1'b1; 
wire id_fsm_s1 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.instr_valid_id == 1'd0) && 
	(core_i.id_stage_i.id_fsm_q == 1'd1) && 
	 1'b1; 
wire id_fsm_s2 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.instr_valid_id == 1'd1) && 
	(core_i.id_stage_i.id_fsm_q == 1'd0) && 
	 1'b1; 
wire id_fsm_s3 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.instr_valid_id == 1'd1) && 
	(core_i.id_stage_i.id_fsm_q == 1'd1) && 
	 1'b1; 
wire mult_fsm_s1 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd1) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire mult_fsm_s2 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd2) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire mult_fsm_s3 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd3) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s1 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd1) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s2 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd2) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s3 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd3) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s4 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd4) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s5 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd5) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire div_sm_s6 = 
	(md_owner_pc == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd6) && 
	(md_owner_v == 1'd1) && 
	 1'b1; 
wire lsu_fsm_s20 = 
	(lsu_owner_pc == pc0) && 
	(core_i.load_store_unit_i.ls_fsm_cs == 3'd2) && 
	(core_i.load_store_unit_i.handle_misaligned_q == 1'd1) && 
	(core_i.load_store_unit_i.pmp_err_q == 1'd0) && 
	(core_i.load_store_unit_i.lsu_err_q == 1'd0) && 
	(lsu_owner_v == 1'd1) && 
	 1'b1; 
