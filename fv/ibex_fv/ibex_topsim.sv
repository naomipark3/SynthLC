//Top-level formal verification wrapper for Ibex RISC-V core
//Analogous to CVA6's topsim.sv
//Wraps ibex_core with all ports connected.
//IF stage is black-boxed by JasperGold: elaborate -bbox_m {ibex_if_stage}
//Key: Register file is EXTERNAL to ibex_core (instantiated here).
//**ICache RAMs are tied off (ICache disabled).

`include "prim_assert.sv"

module ibex_fv import ibex_pkg::*; (
  input logic clk_i,
  input logic rst_ni
);

  //Parameters: basic non-secure config, no ECC, no ICache
  localparam bit          SecureIbex       = 1'b0;
  localparam bit          MemECC           = 1'b0;
  localparam int unsigned MemDataWidth     = 32;
  localparam int unsigned RegFileDataWidth = 32;

  //Tied-off inputs:
  wire [31:0] hart_id_i   = 32'h0;
  wire [31:0] boot_addr_i = 32'h80000000;

  //Interrupts (all disabled):
  wire        irq_software_i  = 1'b0;
  wire        irq_timer_i     = 1'b0;
  wire        irq_external_i  = 1'b0;
  wire [14:0] irq_fast_i      = 15'b0;
  wire        irq_nm_i        = 1'b0;

  //Debug (disabled):
  wire        debug_req_i     = 1'b0;

  //Fetch enable (on):
  wire ibex_mubi_t fetch_enable_i = IbexMuBiOn;

  //ICache scramble key — valid (not used when ICache=0):
  wire ic_scr_key_valid_i = 1'b1;

  //Instruction memory interface
  //IF stage is bbox'd (so these are mostly irrelevant)
  wire        instr_req_o;
  wire [31:0] instr_addr_o;
  wire        instr_gnt_i                       = 1'b1;
  wire        instr_rvalid_i                    = 1'b0;
  wire [MemDataWidth-1:0] instr_rdata_i         = '0;
  wire        instr_err_i                       = 1'b0;

  //Data memory interface (single-cycle grant, 1-cycle read latency):
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

  //Symbolic read data — JG explores all possible values
  wire [MemDataWidth-1:0] data_rdata_i;
  wire data_err_i = 1'b0;

  //Register file — external to ibex_core, instantiated here
  //(Mirrors what ibex_top.sv does with gen_regfile_ff)
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

  //ICache tag/data RAM ports — tied off (ICache=0)
  // IC_NUM_WAYS, IC_INDEX_W, IC_TAG_SIZE, IC_LINE_SIZE from ibex_pkg
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

  //Misc outputs
  wire                    irq_pending_o;
  crash_dump_t            crash_dump_o;
  wire                    double_fault_seen_o;
  wire                    alert_minor_o;
  wire                    alert_major_internal_o;
  wire                    alert_major_bus_o;
  ibex_mubi_t             core_busy_o;

  //Ibex core instantiation
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

    //Instruction memory
    .instr_req_o        (instr_req_o),
    .instr_gnt_i        (instr_gnt_i),
    .instr_rvalid_i     (instr_rvalid_i),
    .instr_addr_o       (instr_addr_o),
    .instr_rdata_i      (instr_rdata_i),
    .instr_err_i        (instr_err_i),

    //Data memory
    .data_req_o         (data_req_o),
    .data_gnt_i         (data_gnt_i),
    .data_rvalid_i      (data_rvalid_i),
    .data_we_o          (data_we_o),
    .data_be_o          (data_be_o),
    .data_addr_o        (data_addr_o),
    .data_wdata_o       (data_wdata_o),
    .data_rdata_i       (data_rdata_i),
    .data_err_i         (data_err_i),

    //Register file (external)
    .dummy_instr_id_o   (dummy_instr_id),
    .dummy_instr_wb_o   (dummy_instr_wb),
    .rf_raddr_a_o       (rf_raddr_a),
    .rf_raddr_b_o       (rf_raddr_b),
    .rf_waddr_wb_o      (rf_waddr_wb),
    .rf_we_wb_o         (rf_we_wb),
    .rf_wdata_wb_ecc_o  (rf_wdata_wb_ecc),
    .rf_rdata_a_ecc_i   (rf_rdata_a_ecc),
    .rf_rdata_b_ecc_i   (rf_rdata_b_ecc),

    //ICache RAMs (tied off)
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

    //Interrupts
    .irq_software_i     (irq_software_i),
    .irq_timer_i        (irq_timer_i),
    .irq_external_i     (irq_external_i),
    .irq_fast_i         (irq_fast_i),
    .irq_nm_i           (irq_nm_i),
    .irq_pending_o      (irq_pending_o),

    //Debug
    .debug_req_i        (debug_req_i),
    .crash_dump_o       (crash_dump_o),

    //Double fault
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

    //Fetch enable
    .fetch_enable_i     (fetch_enable_i),

    //Alerts
    .alert_minor_o           (alert_minor_o),
    .alert_major_internal_o  (alert_major_internal_o),
    .alert_major_bus_o       (alert_major_bus_o),

    //Core busy
    .core_busy_o        (core_busy_o)
  );


endmodule
