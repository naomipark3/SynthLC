i_DIV_0: assume property (i0[31:25] == 7'b0000001);
i_DIV_1: assume property (i0[14:12] == 3'b100);
i_DIV_2: assume property (i0[11:7] != 5'd0);
i_DIV_3: assume property (i0[6:0] == 7'b0110011);
assume property (@(posedge clk_i) core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i == 1'b0);
assume property (@(posedge clk_i) core_i.load_store_unit_i.ls_fsm_cs == 3'd0);
assume property (@(posedge clk_i) core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q == 2'd0);
