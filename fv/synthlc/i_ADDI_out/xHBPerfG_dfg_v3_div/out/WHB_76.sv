`define WHB
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

reg mult_fsm_s5_hpn;
always @(posedge clk_i) begin
    if (!rst_ni) 
        mult_fsm_s5_hpn <= 1'b0;
    else if (mult_fsm_s5)
        mult_fsm_s5_hpn <= 1'b1;
end
reg id_stage_s1_hpn;
always @(posedge clk_i) begin
    if (!rst_ni) 
        id_stage_s1_hpn <= 1'b0;
    else if (id_stage_s1)
        id_stage_s1_hpn <= 1'b1;
end

`ifndef WHB
HB_76: assert property (@(posedge clk_i) (mult_fsm_s5 && !mult_fsm_s5_hpn) |-> !(id_stage_s1_hpn || id_stage_s1));
`else 
//C_76: cover property (@(posedge clk_i) (mult_fsm_s5 && !mult_fsm_s5_hpn) && (id_stage_s1 && !id_stage_s1_hpn));
WHB_76: assert property (@(posedge clk_i) (mult_fsm_s5 && !mult_fsm_s5_hpn) |-> !id_stage_s1_hpn);
WHB_CONCUR_76: assert property (@(posedge clk_i) (mult_fsm_s5 && !mult_fsm_s5_hpn) |-> (id_stage_s1 && !id_stage_s1_hpn));
`endif 
