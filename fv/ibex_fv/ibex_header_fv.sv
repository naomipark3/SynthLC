// Formal environment for Ibex RISC-V core
// IF stage (ibex_if_stage) is black-boxed; its outputs become free variables.
// We constrain them with assumptions to set up symbolic instruction execution.
//
// Analogous to CVA6's header_fv.sv but for Ibex's 2-stage pipeline.
// Signal paths are relative to TOPMOD (ibex_fv) through core_i instance.

`define INTRA_TRANSMITTER

// =============================================================================
// Processor in operation (no reset during verification)
// =============================================================================
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// =============================================================================
// Constrain black-boxed IF stage outputs
// =============================================================================

// No instruction fetch errors
NO_FETCH_ERR: assume property (@(posedge clk_i)
    core_i.instr_fetch_err == 1'b0);

// No instruction fetch error plus (if it exists)
// NO_FETCH_ERR_PLUS: assume property (@(posedge clk_i)
//     core_i.instr_fetch_err_plus == 1'b0);

// Disable interrupts and debug during IUV analysis
NO_IRQ_SW:  assume property (@(posedge clk_i) core_i.irq_software_i == 1'b0);
NO_IRQ_TIM: assume property (@(posedge clk_i) core_i.irq_timer_i == 1'b0);
NO_IRQ_EXT: assume property (@(posedge clk_i) core_i.irq_external_i == 1'b0);
NO_IRQ_FAST: assume property (@(posedge clk_i) core_i.irq_fast_i == 15'b0);
NO_IRQ_NMI: assume property (@(posedge clk_i) core_i.irq_nm_i == 1'b0);
NO_DEBUG:   assume property (@(posedge clk_i) core_i.debug_req_i == 1'b0);

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
// instn_begin is the cycle where IUV enters the ID stage
// =============================================================================
wire instn_begin = (core_i.instr_valid_id &
                    (core_i.pc_id == pc0));

// When PC matches pc0, the instruction encoding must be i0
pc0_i0_assoc: assume property (@(posedge clk_i)
    (core_i.pc_id == pc0 && core_i.instr_valid_id) |->
    core_i.instr_rdata_id == i0);

// IUV issues exactly once: after instn_begin, pc0 never appears again in ID
ISSUE_ONCE: assume property (@(posedge clk_i) instn_begin |=>
    always !(core_i.pc_id == pc0 && core_i.instr_valid_id));

// IUV eventually issues (liveness)
EVENTUAL_ISSUE: assume property (@(posedge clk_i) first |->
    s_eventually(instn_begin));

// When IUV arrives, it should be accepted by ID stage (ready handshake)
// This may need adjustment depending on Ibex's ID stage ready signal
// EXE_IUV: assume property (@(posedge clk_i) instn_begin |-> core_i.id_in_ready);
