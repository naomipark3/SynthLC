// Top-level formal verification wrapper for Ibex RISC-V core
// Analogous to CVA6's topsim.sv
//
// Wraps ibex_core with all ports connected.
// IF stage is black-boxed by JasperGold: elaborate -bbox_m {ibex_if_stage}
//
// Key: Register file is EXTERNAL to ibex_core (instantiated here).
//      ICache RAMs are tied off (ICache disabled).

`include "prim_assert.sv"

module ibex_fv import ibex_pkg::*; (
  input logic clk_i,
  input logic rst_ni
);

  

  // =========================================================================
  // Parameters — basic non-secure config, no ECC, no ICache
  // =========================================================================
  localparam bit          SecureIbex       = 1'b0;
  localparam bit          MemECC           = 1'b0;
  localparam int unsigned MemDataWidth     = 32;
  localparam int unsigned RegFileDataWidth = 32;

  // =========================================================================
  // Tied-off inputs
  // =========================================================================
  wire [31:0] hart_id_i   = 32'h0;
  wire [31:0] boot_addr_i = 32'h80000000;

  // Interrupts — all disabled
  wire        irq_software_i  = 1'b0;
  wire        irq_timer_i     = 1'b0;
  wire        irq_external_i  = 1'b0;
  wire [14:0] irq_fast_i      = 15'b0;
  wire        irq_nm_i        = 1'b0;

  // Debug — disabled
  wire        debug_req_i     = 1'b0;

  // Fetch enable — on
  wire ibex_mubi_t fetch_enable_i = IbexMuBiOn;

  // ICache scramble key — valid (not used when ICache=0)
  wire ic_scr_key_valid_i = 1'b1;

  // =========================================================================
  // Instruction memory interface
  // IF stage is bbox'd, so these are mostly irrelevant
  // =========================================================================
  wire        instr_req_o;
  wire [31:0] instr_addr_o;
  wire        instr_gnt_i                       = 1'b1;
  wire        instr_rvalid_i                    = 1'b0;
  wire [MemDataWidth-1:0] instr_rdata_i         = '0;
  wire        instr_err_i                       = 1'b0;

  // =========================================================================
  // Data memory interface — single-cycle grant, 1-cycle read latency
  // =========================================================================
  wire        data_req_o;
  wire        data_we_o;
  wire [3:0]  data_be_o;
  wire [31:0] data_addr_o;
  wire [MemDataWidth-1:0] data_wdata_o;

  wire        data_gnt_i = 1'b1;

  reg         data_rvalid_q;
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      data_rvalid_q <= 1'b0;
    else
      data_rvalid_q <= data_req_o & data_gnt_i;
  end
  wire data_rvalid_i = data_rvalid_q;

  // Symbolic read data — JG explores all possible values
  wire [MemDataWidth-1:0] data_rdata_i;
  wire data_err_i = 1'b0;

  // =========================================================================
  // Register file — external to ibex_core, instantiated here
  // (Mirrors what ibex_top.sv does with gen_regfile_ff)
  // =========================================================================
  wire [4:0]                  rf_raddr_a;
  wire [4:0]                  rf_raddr_b;
  wire [4:0]                  rf_waddr_wb;
  wire                        rf_we_wb;
  wire [RegFileDataWidth-1:0] rf_wdata_wb_ecc;
  wire [RegFileDataWidth-1:0] rf_rdata_a_ecc;
  wire [RegFileDataWidth-1:0] rf_rdata_b_ecc;
  wire                        dummy_instr_id;
  wire                        dummy_instr_wb;

  ibex_register_file_ff #(
    .RV32E            (1'b0),
    .DataWidth        (RegFileDataWidth),
    .DummyInstructions(1'b0),
    .WrenCheck        (1'b0),
    .RdataMuxCheck    (1'b0),
    .WordZeroVal      (RegFileDataWidth'(0))
  ) register_file_i (
    .clk_i            (clk_i),
    .rst_ni           (rst_ni),
    .test_en_i        (1'b0),
    .dummy_instr_id_i (dummy_instr_id),
    .dummy_instr_wb_i (dummy_instr_wb),
    .raddr_a_i        (rf_raddr_a),
    .rdata_a_o        (rf_rdata_a_ecc),
    .raddr_b_i        (rf_raddr_b),
    .rdata_b_o        (rf_rdata_b_ecc),
    .waddr_a_i        (rf_waddr_wb),
    .wdata_a_i        (rf_wdata_wb_ecc),
    .we_a_i           (rf_we_wb),
    .err_o            ()
  );

  // =========================================================================
  // ICache tag/data RAM ports — tied off (ICache=0)
  // IC_NUM_WAYS, IC_INDEX_W, IC_TAG_SIZE, IC_LINE_SIZE from ibex_pkg
  // =========================================================================
  wire [IC_NUM_WAYS-1:0]  ic_tag_req_o;
  wire                    ic_tag_write_o;
  wire [IC_INDEX_W-1:0]   ic_tag_addr_o;
  wire [IC_TAG_SIZE-1:0]  ic_tag_wdata_o;
  wire [IC_TAG_SIZE-1:0]  ic_tag_rdata_stub [IC_NUM_WAYS];
  assign ic_tag_rdata_stub[0] = '0;
  assign ic_tag_rdata_stub[1] = '0;

  wire [IC_NUM_WAYS-1:0]  ic_data_req_o;
  wire                    ic_data_write_o;
  wire [IC_INDEX_W-1:0]   ic_data_addr_o;
  wire [IC_LINE_SIZE-1:0] ic_data_wdata_o;
  wire [IC_LINE_SIZE-1:0] ic_data_rdata_stub [IC_NUM_WAYS];
  assign ic_data_rdata_stub[0] = '0;
  assign ic_data_rdata_stub[1] = '0;

  wire                    ic_scr_key_req_o;

  // =========================================================================
  // Misc outputs
  // =========================================================================
  wire                    irq_pending_o;
  crash_dump_t            crash_dump_o;
  wire                    double_fault_seen_o;
  wire                    alert_minor_o;
  wire                    alert_major_internal_o;
  wire                    alert_major_bus_o;
  ibex_mubi_t             core_busy_o;

  // =========================================================================
  // Ibex core instantiation
  // =========================================================================
  ibex_core #(
    .PMPEnable         (1'b0),
    .PMPGranularity    (0),
    .PMPNumRegions     (4),
    .MHPMCounterNum    (0),
    .MHPMCounterWidth  (40),
    .RV32E             (1'b0),
    .RV32M             (RV32MFast),
    .RV32B             (RV32BNone),
    .BranchTargetALU   (1'b0),
    .WritebackStage    (1'b1),
    .ICache            (1'b0),
    .ICacheECC         (1'b0),
    .DbgTriggerEn      (1'b0),
    .SecureIbex        (1'b0),
    .DmHaltAddr        (32'h1A110800),
    .DmExceptionAddr   (32'h1A110808)
  ) core_i (
    .clk_i              (clk_i),
    .rst_ni             (rst_ni),

    .hart_id_i          (hart_id_i),
    .boot_addr_i        (boot_addr_i),

    // Instruction memory
    .instr_req_o        (instr_req_o),
    .instr_gnt_i        (instr_gnt_i),
    .instr_rvalid_i     (instr_rvalid_i),
    .instr_addr_o       (instr_addr_o),
    .instr_rdata_i      (instr_rdata_i),
    .instr_err_i        (instr_err_i),

    // Data memory
    .data_req_o         (data_req_o),
    .data_gnt_i         (data_gnt_i),
    .data_rvalid_i      (data_rvalid_i),
    .data_we_o          (data_we_o),
    .data_be_o          (data_be_o),
    .data_addr_o        (data_addr_o),
    .data_wdata_o       (data_wdata_o),
    .data_rdata_i       (data_rdata_i),
    .data_err_i         (data_err_i),

    // Register file (external)
    .dummy_instr_id_o   (dummy_instr_id),
    .dummy_instr_wb_o   (dummy_instr_wb),
    .rf_raddr_a_o       (rf_raddr_a),
    .rf_raddr_b_o       (rf_raddr_b),
    .rf_waddr_wb_o      (rf_waddr_wb),
    .rf_we_wb_o         (rf_we_wb),
    .rf_wdata_wb_ecc_o  (rf_wdata_wb_ecc),
    .rf_rdata_a_ecc_i   (rf_rdata_a_ecc),
    .rf_rdata_b_ecc_i   (rf_rdata_b_ecc),

    // ICache RAMs (tied off)
    .ic_tag_req_o       (ic_tag_req_o),
    .ic_tag_write_o     (ic_tag_write_o),
    .ic_tag_addr_o      (ic_tag_addr_o),
    .ic_tag_wdata_o     (ic_tag_wdata_o),
    .ic_tag_rdata_i     (ic_tag_rdata_stub),
    .ic_data_req_o      (ic_data_req_o),
    .ic_data_write_o    (ic_data_write_o),
    .ic_data_addr_o     (ic_data_addr_o),
    .ic_data_wdata_o    (ic_data_wdata_o),
    .ic_data_rdata_i    (ic_data_rdata_stub),
    .ic_scr_key_valid_i (ic_scr_key_valid_i),
    .ic_scr_key_req_o   (ic_scr_key_req_o),

    // Interrupts
    .irq_software_i     (irq_software_i),
    .irq_timer_i        (irq_timer_i),
    .irq_external_i     (irq_external_i),
    .irq_fast_i         (irq_fast_i),
    .irq_nm_i           (irq_nm_i),
    .irq_pending_o      (irq_pending_o),

    // Debug
    .debug_req_i        (debug_req_i),
    .crash_dump_o       (crash_dump_o),

    // Double fault
    .double_fault_seen_o(double_fault_seen_o),

    

`ifdef RVFI
    .rvfi_valid                  (),
    .rvfi_order                  (),
    .rvfi_insn                   (),
    .rvfi_trap                   (),
    .rvfi_halt                   (),
    .rvfi_intr                   (),
    .rvfi_mode                   (),
    .rvfi_ixl                    (),
    .rvfi_rs1_addr               (),
    .rvfi_rs2_addr               (),
    .rvfi_rs3_addr               (),
    .rvfi_rs1_rdata              (),
    .rvfi_rs2_rdata              (),
    .rvfi_rs3_rdata              (),
    .rvfi_rd_addr                (),
    .rvfi_rd_wdata               (),
    .rvfi_pc_rdata               (),
    .rvfi_pc_wdata               (),
    .rvfi_mem_addr               (),
    .rvfi_mem_rmask              (),
    .rvfi_mem_wmask              (),
    .rvfi_mem_rdata              (),
    .rvfi_mem_wdata              (),
    .rvfi_ext_pre_mip            (),
    .rvfi_ext_post_mip           (),
    .rvfi_ext_nmi                (),
    .rvfi_ext_nmi_int            (),
    .rvfi_ext_debug_req          (),
    .rvfi_ext_debug_mode         (),
    .rvfi_ext_rf_wr_suppress     (),
    .rvfi_ext_mcycle             (),
    .rvfi_ext_mhpmcounters       (),
    .rvfi_ext_mhpmcountersh      (),
    .rvfi_ext_ic_scr_key_valid   (),
    .rvfi_ext_irq_valid          (),
    .rvfi_ext_expanded_insn_valid(),
    .rvfi_ext_expanded_insn      (),
    .rvfi_ext_expanded_insn_last (),
`endif

    // Fetch enable
    .fetch_enable_i     (fetch_enable_i),

    // Alerts
    .alert_minor_o           (alert_minor_o),
    .alert_major_internal_o  (alert_major_internal_o),
    .alert_major_bus_o       (alert_major_bus_o),

    // Core busy
    .core_busy_o        (core_busy_o)
  );


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
// NIA header — base assumptions provided by FVMACRO in RUN_JG.sh

// =============================================================================
// ## Performing location annotation
// ============================================================================= 


wire id_stage_s1 = 
	(core_i.id_stage_i.pc_id_i == pc0) && 
	(core_i.id_stage_i.instr_executing == 1'd1) && 
	 1'b1; 
wire mult_fsm_s1 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd0) && 
	(mult_state == 2'd1) && 
	 1'b1; 
wire mult_fsm_s2 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd0) && 
	(mult_state == 2'd2) && 
	 1'b1; 
wire mult_fsm_s3 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd0) && 
	(mult_state == 2'd3) && 
	 1'b1; 
wire mult_fsm_s5 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd1) && 
	(mult_state == 2'd1) && 
	 1'b1; 
wire mult_fsm_s6 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd1) && 
	(mult_state == 2'd2) && 
	 1'b1; 
wire mult_fsm_s7 = 
	(mul_owner_pc == pc0) && 
	(mul_owner_v == 1'd1) && 
	(mult_state == 2'd3) && 
	 1'b1; 
wire div_fsm_s1 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd1) && 
	 1'b1; 
wire div_fsm_s10 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd2) && 
	 1'b1; 
wire div_fsm_s11 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd3) && 
	 1'b1; 
wire div_fsm_s12 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd4) && 
	 1'b1; 
wire div_fsm_s13 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd5) && 
	 1'b1; 
wire div_fsm_s14 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd6) && 
	 1'b1; 
wire div_fsm_s2 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd2) && 
	 1'b1; 
wire div_fsm_s3 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd3) && 
	 1'b1; 
wire div_fsm_s4 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd4) && 
	 1'b1; 
wire div_fsm_s5 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd5) && 
	 1'b1; 
wire div_fsm_s6 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd0) && 
	(div_state == 3'd6) && 
	 1'b1; 
wire div_fsm_s9 = 
	(div_owner_pc == pc0) && 
	(div_owner_v == 1'd1) && 
	(div_state == 3'd1) && 
	 1'b1; 
wire lsu_fsm_s10 = 
	(lsu_owner_pc == pc0) && 
	(lsu_owner_v == 1'd1) && 
	(ls_fsm == 3'd2) && 
	 1'b1; 
wire lsu_fsm_s2 = 
	(lsu_owner_pc == pc0) && 
	(lsu_owner_v == 1'd0) && 
	(ls_fsm == 3'd2) && 
	 1'b1; 
wire lsu_fsm_s8 = 
	(lsu_owner_pc == pc0) && 
	(lsu_owner_v == 1'd1) && 
	(ls_fsm == 3'd0) && 
	 1'b1; 
wire wb_stage_s1 = 
	(core_i.cs_registers_i.pc_wb_i == pc0) && 
	(core_i.wb_stage_i.g_writeback_stage.wb_valid_q == 1'd1) && 
	 1'b1; 
i_ADDI_0: assume property (i0[14:12] == 3'b000);
i_ADDI_1: assume property (i0[11:7] != 5'd0);
i_ADDI_2: assume property (i0[6:0] == 7'b0010011);

reg id_stage_s1_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        id_stage_s1_hpn <= 1'b0;
    else if (id_stage_s1)
        id_stage_s1_hpn <= 1'b1;
end

reg mult_fsm_s1_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s1_hpn <= 1'b0;
    else if (mult_fsm_s1)
        mult_fsm_s1_hpn <= 1'b1;
end

reg mult_fsm_s2_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s2_hpn <= 1'b0;
    else if (mult_fsm_s2)
        mult_fsm_s2_hpn <= 1'b1;
end

reg mult_fsm_s3_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s3_hpn <= 1'b0;
    else if (mult_fsm_s3)
        mult_fsm_s3_hpn <= 1'b1;
end

reg mult_fsm_s5_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s5_hpn <= 1'b0;
    else if (mult_fsm_s5)
        mult_fsm_s5_hpn <= 1'b1;
end

reg mult_fsm_s6_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s6_hpn <= 1'b0;
    else if (mult_fsm_s6)
        mult_fsm_s6_hpn <= 1'b1;
end

reg mult_fsm_s7_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        mult_fsm_s7_hpn <= 1'b0;
    else if (mult_fsm_s7)
        mult_fsm_s7_hpn <= 1'b1;
end

reg div_fsm_s1_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s1_hpn <= 1'b0;
    else if (div_fsm_s1)
        div_fsm_s1_hpn <= 1'b1;
end

reg div_fsm_s10_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s10_hpn <= 1'b0;
    else if (div_fsm_s10)
        div_fsm_s10_hpn <= 1'b1;
end

reg div_fsm_s11_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s11_hpn <= 1'b0;
    else if (div_fsm_s11)
        div_fsm_s11_hpn <= 1'b1;
end

reg div_fsm_s12_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s12_hpn <= 1'b0;
    else if (div_fsm_s12)
        div_fsm_s12_hpn <= 1'b1;
end

reg div_fsm_s13_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s13_hpn <= 1'b0;
    else if (div_fsm_s13)
        div_fsm_s13_hpn <= 1'b1;
end

reg div_fsm_s14_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s14_hpn <= 1'b0;
    else if (div_fsm_s14)
        div_fsm_s14_hpn <= 1'b1;
end

reg div_fsm_s2_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s2_hpn <= 1'b0;
    else if (div_fsm_s2)
        div_fsm_s2_hpn <= 1'b1;
end

reg div_fsm_s3_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s3_hpn <= 1'b0;
    else if (div_fsm_s3)
        div_fsm_s3_hpn <= 1'b1;
end

reg div_fsm_s4_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s4_hpn <= 1'b0;
    else if (div_fsm_s4)
        div_fsm_s4_hpn <= 1'b1;
end

reg div_fsm_s5_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s5_hpn <= 1'b0;
    else if (div_fsm_s5)
        div_fsm_s5_hpn <= 1'b1;
end

reg div_fsm_s6_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s6_hpn <= 1'b0;
    else if (div_fsm_s6)
        div_fsm_s6_hpn <= 1'b1;
end

reg div_fsm_s9_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        div_fsm_s9_hpn <= 1'b0;
    else if (div_fsm_s9)
        div_fsm_s9_hpn <= 1'b1;
end

reg wb_stage_s1_hpn;
always @(posedge clk_i) begin
    if (!rst_ni)
        wb_stage_s1_hpn <= 1'b0;
    else if (wb_stage_s1)
        wb_stage_s1_hpn <= 1'b1;
end

assume property (@(posedge clk_i) !mult_fsm_s1); 
assume property (@(posedge clk_i) !mult_fsm_s2); 
assume property (@(posedge clk_i) !mult_fsm_s3); 
assume property (@(posedge clk_i) !mult_fsm_s5); 
assume property (@(posedge clk_i) !mult_fsm_s6); 
assume property (@(posedge clk_i) !mult_fsm_s7); 
assume property (@(posedge clk_i) !div_fsm_s1); 
assume property (@(posedge clk_i) !div_fsm_s11); 
assume property (@(posedge clk_i) !div_fsm_s12); 
assume property (@(posedge clk_i) !div_fsm_s13); 
assume property (@(posedge clk_i) !div_fsm_s14); 
assume property (@(posedge clk_i) !div_fsm_s2); 
assume property (@(posedge clk_i) !div_fsm_s3); 
assume property (@(posedge clk_i) !div_fsm_s4); 
assume property (@(posedge clk_i) !div_fsm_s5); 
assume property (@(posedge clk_i) !wb_stage_s1); 
C_78_N: cover property (@(posedge clk_i) id_stage_s1_hpn & div_fsm_s10_hpn & div_fsm_s6_hpn & div_fsm_s9_hpn & 1'b1 & !(id_stage_s1 | div_fsm_s10 | div_fsm_s6 | div_fsm_s9 | 1'b0));
endmodule
