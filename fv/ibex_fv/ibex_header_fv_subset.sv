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
