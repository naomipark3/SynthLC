// Formal environment for Ibex RISC-V core
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

NO_INSTR_ERR: assume property (@(posedge clk_i) 
    core_i.instr_err_i == 1'b0);

NO_DATA_ERR: assume property (@(posedge clk_i) 
    core_i.data_err_i == 1'b0);

// Disable interrupts and debug during IUV analysis
NO_IRQ_SW:  assume property (@(posedge clk_i) core_i.irq_software_i == 1'b0);
NO_IRQ_TIM: assume property (@(posedge clk_i) core_i.irq_timer_i == 1'b0);
NO_IRQ_EXT: assume property (@(posedge clk_i) core_i.irq_external_i == 1'b0);
NO_IRQ_FAST: assume property (@(posedge clk_i) core_i.irq_fast_i == 15'b0);
NO_IRQ_NMI: assume property (@(posedge clk_i) core_i.irq_nm_i == 1'b0);
NO_DEBUG:   assume property (@(posedge clk_i) core_i.debug_req_i == 1'b0);

// =============================================================================
// IUV lifecycle (multi-cycle safe)
// =============================================================================

wire [31:0] pc0;
pc0_const:  assume property (@(posedge clk_i) CONST(pc0));
pc0_nozero: assume property (@(posedge clk_i) pc0 != '0);

wire [31:0] i0;
i0_const: assume property (@(posedge clk_i) CONST(i0));

wire iuv_in_id = (core_i.instr_valid_id && (core_i.pc_id == pc0));

wire mult_commit_cond = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_hold 
                     || core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_internal;

wire div_commit_cond = (core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q != 0) 
                    || core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_internal 
                    || core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_hold;

wire lsu_commit_cond = (core_i.load_store_unit_i.ls_fsm_cs != 0) 
                    || core_i.load_store_unit_i.lsu_req_i;

pc0_i0_assoc: assume property (@(posedge clk_i)
    iuv_in_id |-> (core_i.instr_rdata_id == i0));

logic instn_begun;
wire  instn_begin = iuv_in_id && !instn_begun;
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) instn_begun <= 1'b0;
  else if (instn_begin) instn_begun <= 1'b1;
end

wire instn_retire = core_i.id_stage_i.instr_id_done_o && iuv_in_id;

logic instn_done;
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) instn_done <= 1'b0;
  else if (instn_retire) instn_done <= 1'b1;
end

// 'first' signal for liveness
reg first;
initial first = 1'b1;
always @(posedge clk_i) first <= 1'b0;

EVENTUAL_ISSUE: assume property (@(posedge clk_i)
    first |-> s_eventually(instn_begin));

EVENTUAL_RETIRE: assume property (@(posedge clk_i)
    instn_begun |-> s_eventually(instn_retire));

ISSUE_ONCE: assume property (@(posedge clk_i)
    instn_done |-> !iuv_in_id);

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
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd1) && 
	 1'b1; 
wire mult_fsm_s2 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd1) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd0) && 
	 1'b1; 
wire mult_fsm_s3 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd1) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd1) && 
	 1'b1; 
wire mult_fsm_s4 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd2) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd0) && 
	 1'b1; 
wire mult_fsm_s5 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd2) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd1) && 
	 1'b1; 
wire mult_fsm_s6 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd3) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd0) && 
	 1'b1; 
wire mult_fsm_s7 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd3) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s1 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s10 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd5) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s11 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd5) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s12 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd6) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s13 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd6) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s2 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd1) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s3 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd1) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s4 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd2) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s5 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd2) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s6 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd3) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s7 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd3) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire div_sm_s8 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd4) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd0) && 
	 1'b1; 
wire div_sm_s9 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd4) && 
	(core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i == 1'd1) && 
	 1'b1; 
wire lsu_fsm_s2 = 
	(core_i.if_stage_i.pc_id_o == pc0) && 
	(core_i.load_store_unit_i.ls_fsm_cs == 3'd2) && 
	 1'b1; 
// Ibex formal environment — Subset assumptions
// CVA6 uses this to constrain scoreboard slots and instruction types.
// Ibex has no scoreboard, so no IASUBSET needed.
// Optionally constrain instruction types for faster verification.

// IASUBSET_2: assume property (@(posedge clk_i)
// // ADD
// ((core_i.instr_rdata_id[31:25] == 7'b0000000) && (core_i.instr_rdata_id[14:12] == 3'b000)
// && (core_i.instr_rdata_id[11:7] != 5'd0) && (core_i.instr_rdata_id[6:0] == 7'b0110011))
// ||
// // BEQ
// ((core_i.instr_rdata_id[14:12] == 3'b000) && (core_i.instr_rdata_id[6:0] == 7'b1100011))
// ||
// // SW
// ((core_i.instr_rdata_id[14:12] == 3'b010) && (core_i.instr_rdata_id[6:0] == 7'b0100011))
// ||
// // LW
// ((core_i.instr_rdata_id[14:12] == 3'b010) && (core_i.instr_rdata_id[11:7] != 5'd0) && (core_i.instr_rdata_id[6:0] == 7'b0000011))
// );
