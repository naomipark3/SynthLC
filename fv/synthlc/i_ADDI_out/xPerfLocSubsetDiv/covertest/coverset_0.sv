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
assume property (@(posedge clk_i) !div_fsm_s10); 
assume property (@(posedge clk_i) !div_fsm_s11); 
assume property (@(posedge clk_i) !div_fsm_s12); 
assume property (@(posedge clk_i) !div_fsm_s13); 
assume property (@(posedge clk_i) !div_fsm_s14); 
assume property (@(posedge clk_i) !div_fsm_s2); 
assume property (@(posedge clk_i) !div_fsm_s3); 
assume property (@(posedge clk_i) !div_fsm_s4); 
assume property (@(posedge clk_i) !div_fsm_s5); 
assume property (@(posedge clk_i) !div_fsm_s6); 
assume property (@(posedge clk_i) !div_fsm_s9); 
assume property (@(posedge clk_i) !wb_stage_s1); 
C_0_N: cover property (@(posedge clk_i) id_stage_s1_hpn & 1'b1 & !(id_stage_s1 | 1'b0));