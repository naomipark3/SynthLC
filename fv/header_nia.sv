// Ibex header for non-interference (NI) analysis
// IF stage (ibex_if_stage) is black-boxed; its outputs become free variables.
// Signal paths are relative to TOPMOD (ibex_fv) through core_i instance.

`define INTRA_TRANSMITTER

// =============================================================================
// Processor in operation (no reset during verification)
// =============================================================================
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// =============================================================================
// Constrain black-boxed IF stage outputs
// =============================================================================

NO_FETCH_ERR: assume property (@(posedge clk_i)
    core_i.instr_fetch_err == 1'b0);

NO_IRQ_SW:   assume property (@(posedge clk_i) core_i.irq_software_i == 1'b0);
NO_IRQ_TIM:  assume property (@(posedge clk_i) core_i.irq_timer_i == 1'b0);
NO_IRQ_EXT:  assume property (@(posedge clk_i) core_i.irq_external_i == 1'b0);
NO_IRQ_FAST: assume property (@(posedge clk_i) core_i.irq_fast_i == 15'b0);
NO_IRQ_NMI:  assume property (@(posedge clk_i) core_i.irq_nm_i == 1'b0);
NO_DEBUG:    assume property (@(posedge clk_i) core_i.debug_req_i == 1'b0);

// =============================================================================
// Set up instruction of interest
// =============================================================================
wire [32-1:0] i0;
i0_const: assume property (@(posedge clk_i) CONST(i0));

// =============================================================================
// Set up pc value, instruction issue, and execution contexts
// =============================================================================
wire [32-1:0] pc0;

pc0_const:  assume property (@(posedge clk_i) CONST(pc0));
pc0_nozero: assume property (@(posedge clk_i) pc0 != '0);

wire instn_begin = (core_i.instr_valid_id &&
                    core_i.pc_id == pc0);

pc0_i0_assoc_1: assume property (@(posedge clk_i)
    core_i.pc_id == pc0 |-> core_i.instr_rdata_id == i0);
pc0_i0_assoc_2: assume property (@(posedge clk_i)
    core_i.pc_id == pc0 |->
    (core_i.instr_valid_id == 1'b1 &&
    core_i.instr_fetch_err == 1'b0)
);

NO_INSTN_INTERFERENCE_1: assume property (@(posedge clk_i) first |->
        instn_begin);
NO_INSTN_INTERFERENCE_2: assume property (@(posedge clk_i) first |=>
    always !(core_i.instr_valid_id));

ISSUE_ONCE: assume property (@(posedge clk_i) instn_begin |=>
        always !(core_i.pc_id == pc0 && core_i.instr_valid_id));

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

