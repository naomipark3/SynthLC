// NIA header — base assumptions provided by FVMACRO in RUN_JG.sh

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
