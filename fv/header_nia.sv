// Ibex header for non-interference (NI) analysis
// IF stage (ibex_if_stage) is black-boxed; its outputs become free variables.
// Signal paths are relative to TOPMOD (ibex_fv) through core_i instance.

`define INTRA_TRANSMITTER // we care about behavior within one instruction, not between two

// Processor in operation (no reset during verification). This forces the core to never reset during verification.
// Avoids trivial proofs where everything resets and nothing executes.
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// Constrain black-boxed IF stage outputs -> prevent spurious fetch errors, keeps instruction delivery "clean"
NO_FETCH_ERR: assume property (@(posedge clk_i)
    core_i.instr_fetch_err == 1'b0);

// Disable all asynchronous interference. The following commands eliminate all control-flow distruptions (i.e. interrupts, NMIs, debug entry)
// As a result, the instruction's path is determined only by its opcode and operands
NO_IRQ_SW:   assume property (@(posedge clk_i) core_i.irq_software_i == 1'b0);
NO_IRQ_TIM:  assume property (@(posedge clk_i) core_i.irq_timer_i == 1'b0);
NO_IRQ_EXT:  assume property (@(posedge clk_i) core_i.irq_external_i == 1'b0);
NO_IRQ_FAST: assume property (@(posedge clk_i) core_i.irq_fast_i == 15'b0);
NO_IRQ_NMI:  assume property (@(posedge clk_i) core_i.irq_nm_i == 1'b0);
NO_DEBUG:    assume property (@(posedge clk_i) core_i.debug_req_i == 1'b0);

// Set up instruction of interest. i0 is unconstrainted but constant over time
wire [32-1:0] i0;
i0_const: assume property (@(posedge clk_i) CONST(i0));


// Symbolic PC for that instruction
wire [32-1:0] pc0;

// define PC to be constant and nonzero (avoid reset/boot corner cases)
pc0_const:  assume property (@(posedge clk_i) CONST(pc0));
pc0_nozero: assume property (@(posedge clk_i) pc0 != '0);

// Detect when this instruction begins execution
wire instn_begin = (core_i.instr_valid_id &&
                    core_i.pc_id == pc0);

//Bind instruction bits to the PC:
pc0_i0_assoc_1: assume property (@(posedge clk_i)
                                 core_i.pc_id == pc0 |-> core_i.instr_rdata_id == i0); //if the PC matches pc0, then the instruction bits must be i0
//enforce valid, error free issue, meaning if pc0 appears, instruction is valid and there's no fetch error
pc0_i0_assoc_2: assume property (@(posedge clk_i)
    core_i.pc_id == pc0 |->
    (core_i.instr_valid_id == 1'b1 &&
    core_i.instr_fetch_err == 1'b0)
);

//At time 0, the first instruction must be i0.
NO_INSTN_INTERFERENCE_1: assume property (@(posedge clk_i) first |->
        instn_begin);

//After that, no other instructions ever appear --> CREATES A SINGLE-INSTRUCTION UNIVERSE
NO_INSTN_INTERFERENCE_2: assume property (@(posedge clk_i) first |=>
    always !(core_i.instr_valid_id));

//Once instruction i0@pc0 issues, it's never re-issued --> prevents replays, stalls that look like reissue, or loops
ISSUE_ONCE: assume property (@(posedge clk_i) instn_begin |=>
        always !(core_i.pc_id == pc0 && core_i.instr_valid_id));

//Define the PLs that RTL2M\muPATH will track; each line tells the tool which microFSM each instruction is in. 
//The following 6 controller FSM states correspond to Ibex pipeline controller states
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

//instruction controller states decide when instructions can decode, stall, flush, or retire while the instruction FSM decides how long a specific instruction stays active
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

