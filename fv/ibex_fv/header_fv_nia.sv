// Ibex formal environment — NIA (No Instruction After) variant
// IUV issued at first cycle after reset, then no more valid instructions.
// IF stage (ibex_if_stage) is black-boxed.

`define INTRA_TRANSMITTER

// =============================================================================
// Processor in operation (no reset during verification)
// =============================================================================
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// No interrupts, no debug
NO_IRQ_SW:   assume property (@(posedge clk_i) core_i.irq_software_i == 1'b0);
NO_IRQ_TIM:  assume property (@(posedge clk_i) core_i.irq_timer_i == 1'b0);
NO_IRQ_EXT:  assume property (@(posedge clk_i) core_i.irq_external_i == 1'b0);
NO_IRQ_FAST: assume property (@(posedge clk_i) core_i.irq_fast_i == 15'b0);
NO_IRQ_NMI:  assume property (@(posedge clk_i) core_i.irq_nm_i == 1'b0);
NO_DEBUG:    assume property (@(posedge clk_i) core_i.debug_req_i == 1'b0);

// No fetch errors
NO_FETCH_ERR: assume property (@(posedge clk_i) core_i.instr_fetch_err == 1'b0);

// =============================================================================
// Set up instruction of interest (IUV)
// =============================================================================
wire [31:0] i0;
i0_const: assume property (@(posedge clk_i) CONST(i0));

// =============================================================================
// Set up PC value
// =============================================================================
wire [31:0] pc0;
pc0_const:  assume property (@(posedge clk_i) CONST(pc0));
pc0_nozero: assume property (@(posedge clk_i) pc0 != '0);

// =============================================================================
// Instruction begin: valid instruction at ID stage with matching PC
// =============================================================================
wire instn_begin = (core_i.instr_valid_id &
                    (core_i.pc_id == pc0));

// When PC matches pc0, the instruction encoding must be i0, and it's valid
pc0_i0_assoc: assume property (@(posedge clk_i)
    (core_i.pc_id == pc0 && core_i.instr_valid_id) |->
    core_i.instr_rdata_id == i0);

// =============================================================================
// NIA: IUV issued at first cycle, no instructions after
// =============================================================================
NO_INSTN_INTERFERENCE_1: assume property (@(posedge clk_i) first |->
        instn_begin);
NO_INSTN_INTERFERENCE_2: assume property (@(posedge clk_i) first |=>
    always !(core_i.instr_valid_id));

ISSUE_ONCE: assume property (@(posedge clk_i) instn_begin |=>
        always !(core_i.pc_id == pc0 && core_i.instr_valid_id));
