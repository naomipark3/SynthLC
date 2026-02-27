// =============================================================================
// Formal environment for Ibex RISC-V core (SynthLC / RTL2MuPATH harness)
//
// Goal:
//   - IF stage is black-boxed => its outputs are free variables.
//   - Constrain frontend-related error/interrupt/debug inputs to simplify
//     IUV analysis.
//   - Symbolic (pc0, i0) tracked at ID stage.
//   - Multi-cycle safe: do NOT assume pc_id stays pc0 during mul/div/lsu.
//
// Constraints added vs. original file:
//   [A] IF_ID_CONTRACT  -- IF/ID register stability during stall
//   [B] VALID_INSTN     -- frontend always presenting valid instruction
//   [C] NOHALT_FSM      -- block sleep/debug FSM states
//   [D] NOHALT_IF       -- id_in_ready stays high (halt_if is internal-only)
//   [E] NOHALT_BUSY     -- core stays busy (ctrl_busy wire in ibex_core.sv)
//   [F] EXE_IUV         -- IUV immediately accepted when first presented
//
// Signal path notes:
//   - halt_if        : INTERNAL to ibex_controller, never a port. Effect
//                      observable via core_i.id_in_ready.
//   - core_sleep_o   : Does NOT exist in Ibex. Use core_i.ctrl_busy instead.
//   - halt_if_o      : Does NOT exist as a port. Use core_i.id_in_ready.
//   - pc width       : 32-bit (unlike CVA6's 64-bit).
// =============================================================================

`define INTRA_TRANSMITTER

// =============================================================================
// [1] Processor in operation (no reset during verification)
// =============================================================================
IN_OP_MODE: assume property (@(posedge clk_i) rst_ni == 1'b1);

// =============================================================================
// [2] Constrain black-boxed frontend / external inputs
// =============================================================================
NO_FETCH_ERR: assume property (@(posedge clk_i) core_i.instr_fetch_err  == 1'b0);
NO_INSTR_ERR: assume property (@(posedge clk_i) core_i.instr_err_i      == 1'b0);
NO_DATA_ERR:  assume property (@(posedge clk_i) core_i.data_err_i       == 1'b0);

// Disable interrupts and debug during IUV analysis
NO_IRQ_SW:    assume property (@(posedge clk_i) core_i.irq_software_i   == 1'b0);
NO_IRQ_TIM:   assume property (@(posedge clk_i) core_i.irq_timer_i      == 1'b0);
NO_IRQ_EXT:   assume property (@(posedge clk_i) core_i.irq_external_i   == 1'b0);
NO_IRQ_FAST:  assume property (@(posedge clk_i) core_i.irq_fast_i       == 15'b0);
NO_IRQ_NMI:   assume property (@(posedge clk_i) core_i.irq_nm_i         == 1'b0);
NO_DEBUG:     assume property (@(posedge clk_i) core_i.debug_req_i      == 1'b0);

// =============================================================================
// [3] IF/ID pipeline register stability contract                          [NEW A]
//
// When IF has a valid instruction waiting (instr_valid_id == 1) but ID is
// not yet ready to consume it (id_in_ready == 0), and no pipeline flush is
// in progress (instr_valid_clear == 0), the IF/ID register contents must
// remain stable on the next cycle.
//
// Signals:
//   VALID : core_i.instr_valid_id       -- instruction waiting in IF/ID reg
//   READY : core_i.id_in_ready          -- ID ready to accept from IF
//   FLUSH : core_i.instr_valid_clear    -- pipeline flush from controller
//   DATA1 : core_i.instr_rdata_id       -- instruction bits
//   DATA2 : core_i.if_stage_i.pc_id_o  -- PC of instruction
//   DATA3 : core_i.instr_fetch_err      -- fetch error flag
//
// Guard against flush cycle: during a flush, instr_valid_id legitimately
// drops to 0 — we must not constrain that away.
// =============================================================================
IF_ID_CONTRACT: assume property (@(posedge clk_i)
  (core_i.instr_valid_id        &&
   !core_i.id_in_ready          &&
   !core_i.instr_valid_clear       // not being flushed this cycle
  ) |=>
  (
    ($past(core_i.instr_valid_id)       == core_i.instr_valid_id)       &&
    ($past(core_i.instr_rdata_id)       == core_i.instr_rdata_id)       &&
    ($past(core_i.if_stage_i.pc_id_o)  == core_i.if_stage_i.pc_id_o)  &&
    ($past(core_i.instr_fetch_err)      == core_i.instr_fetch_err)
  )
);

// =============================================================================
// [4] Frontend always presenting a valid instruction to ID stage          [NEW B]
//
// Since IF is black-boxed, assume the prefetch buffer always has an
// instruction ready. Guard against flush cycles where instr_valid_id
// legitimately deasserts.
//
// Signal: core_i.instr_valid_id   (ibex_core.sv logic wire)
//         core_i.instr_valid_clear (ibex_core.sv, driven by id_stage)
// =============================================================================
VALID_INSTN: assume property (@(posedge clk_i)
  !core_i.instr_valid_clear |-> core_i.instr_valid_id == 1'b1
);

// =============================================================================
// [5] NOHALT: Prevent core from entering halted / sleep / debug state    [NEW C/D/E]
//
// Unlike CVA6's single halt_i input, Ibex generates halt internally via the
// Controller FSM. Three layers of protection:
//
// Layer 1 — FSM state (root cause):
//   Allowed: RESET, BOOT_SET, FIRST_FETCH, DECODE, FLUSH
//   Blocked: WAIT_SLEEP, SLEEP, DBG_TAKEN_IF, DBG_TAKEN_ID
//   Note: verify encoding in your ibex_pkg.sv — use named enum values.
//
// Layer 2 — id_in_ready (halt_if effect):
//   halt_if is INTERNAL to ibex_controller, never exposed as a port.
//   Its effect propagates as id_in_ready going low.
//   Signal: core_i.id_in_ready  (wire in ibex_core.sv,
//                                 driven by id_stage_i.id_in_ready_o)
//
// Layer 3 — ctrl_busy (sleep indicator):
//   core_sleep_o does NOT exist in Ibex.
//   ctrl_busy == 1 → core active
//   ctrl_busy == 0 → core idle/sleeping  ← block this
//   Signal: core_i.ctrl_busy  (wire in ibex_core.sv,
//                               driven by id_stage_i.ctrl_busy_o)
// =============================================================================

// Layer 1: Block halt/sleep/debug FSM states at root cause
NOHALT_FSM: assume property (@(posedge clk_i)
  core_i.id_stage_i.controller_i.ctrl_fsm_cs inside {
    ibex_pkg::RESET,
    ibex_pkg::BOOT_SET,
    ibex_pkg::FIRST_FETCH,
    ibex_pkg::DECODE,
    ibex_pkg::FLUSH
  }
);

// Layer 2: id_in_ready must stay high
// (halt_if internal wire has no port; this is its observable effect)
NOHALT_IF: assume property (@(posedge clk_i)
  core_i.id_in_ready == 1'b1
);

// Layer 3: Core must remain busy (never enter sleep)
NOHALT_BUSY: assume property (@(posedge clk_i)
  core_i.ctrl_busy == 1'b1
);

// =============================================================================
// [6] Symbolic instruction of interest: (pc0, i0)
//
// pc0: 32-bit (Ibex is RV32 — unlike CVA6's 64-bit pc0)
// i0:  32-bit instruction encoding
// Both are symbolic constants held stable across all cycles.
// =============================================================================
wire [31:0] pc0;
pc0_const:  assume property (@(posedge clk_i) $stable(pc0));
pc0_nozero: assume property (@(posedge clk_i) pc0 != 32'h0);

wire [31:0] i0;
i0_const:   assume property (@(posedge clk_i) $stable(i0));

// =============================================================================
// [7] IUV definition at ID stage
//
// iuv_in_id: IUV is currently sitting in ID stage (valid + PC matches)
// pc0_i0_assoc: when IUV is in ID, instruction bits must equal i0
//               and no fetch exception may be active
//
// Signals:
//   core_i.instr_valid_id   -- valid instruction in IF/ID register
//   core_i.if_stage_i.pc_id_o -- PC of instruction in IF/ID register
//   core_i.instr_rdata_id   -- instruction bits in IF/ID register
//   core_i.instr_fetch_err  -- fetch error (must be 0 for IUV)
//
// NOTE: use pc_id_o consistently from if_stage_i throughout — do not mix
// with core_i.pc_id if that resolves to a different path.
// =============================================================================
wire iuv_in_id = (core_i.instr_valid_id &&
                  (core_i.if_stage_i.pc_id_o == pc0));

pc0_i0_assoc: assume property (@(posedge clk_i)
  iuv_in_id |->
  (core_i.instr_rdata_id == i0 &&
   core_i.instr_fetch_err == 1'b0)
);

// =============================================================================
// [8] Issue-once bookkeeping
//
// instn_begun: flop set when IUV is seen in ID for the first time
// instn_begin: pulse on the first cycle IUV appears in ID
// ISSUE_ONCE:  after instn_begun, pc0 must not reappear in ID
// =============================================================================
logic instn_begun;
wire  instn_begin = iuv_in_id && !instn_begun;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) instn_begun <= 1'b0;
  else if (instn_begin) instn_begun <= 1'b1;
end

ISSUE_ONCE: assume property (@(posedge clk_i)
  instn_begun |-> !iuv_in_id
);

// =============================================================================
// [9] Liveness: IUV is eventually issued
// =============================================================================
reg first;
initial first = 1'b1;
always @(posedge clk_i) first <= 1'b0;

EVENTUAL_ISSUE: assume property (@(posedge clk_i)
  first |-> s_eventually(instn_begin)
);

// =============================================================================
// [10] EXE_IUV: IUV is immediately accepted by ID when first presented   [NEW F]
//
// When instn_begin fires, id_in_ready must be high so the IUV is consumed
// in that same cycle. Without this, ISSUE_ONCE fires before the IUV is
// actually processed and the model checker loses track of the instruction.
//
// Signal: core_i.id_in_ready
//   (same wire used in NOHALT_IF — redundant if NOHALT_IF is kept globally,
//    but retained here for explicit documentation of IUV-specific intent)
//
// Ibex equivalent of CVA6: instn_begin |-> fetch_ready_id_if
// =============================================================================
EXE_IUV: assume property (@(posedge clk_i)
  instn_begin |-> core_i.id_in_ready
);

// =============================================================================
// [11] µFSM owner tracking: ID / WB stage PL observation
// =============================================================================
wire [31:0] pc_id   = core_i.if_stage_i.pc_id_o;
wire        id_valid = core_i.id_stage_i.instr_executing;
wire        id_fsm   = core_i.id_stage_i.id_fsm_q; // 0=FIRST_CYCLE 1=MULTI_CYCLE

wire [31:0] wb_pc    = core_i.wb_stage_i.g_writeback_stage.wb_pc_q;
wire        wb_valid = core_i.wb_stage_i.g_writeback_stage.wb_valid_q;


// [11B] track when the IUV reaches WB with instn_retired signal and add additional
// constraint to prevent mult/div from starting at all while the IUV is in-flight
// for ADDI, BEQ, and LW
logic instn_retired;
wire  instn_retire = instn_begun && wb_valid && (wb_pc == pc0);

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni)          instn_retired <= 1'b0;
  else if (instn_retire) instn_retired <= 1'b1;
end

NOMULTDIV_DURING_IUV: assume property (@(posedge clk_i)
  (instn_begun && !instn_retired) |->
    (core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q == 3'd0) &&
    (mult_state == 2'd0)
);

// =============================================================================
// [12] µFSM owner tracking: LSU
//
// lsu_owner_pc/v tracks which instruction currently owns the LSU.
// lsu_start: LSU is idle (ls_fsm==IDLE==0) and a new request arrives
// lsu_end:   owning instruction's response is valid
//
// NOTE: verify ls_fsm IDLE encoding == 3'd0 in your Ibex version.
// =============================================================================
logic [31:0] lsu_owner_pc;
logic        lsu_owner_v;
wire  [2:0]  ls_fsm = core_i.load_store_unit_i.ls_fsm_cs;

wire lsu_start = core_i.load_store_unit_i.lsu_req_i &&
                 (ls_fsm == 3'd0) && !lsu_owner_v;  // IDLE == 0
wire lsu_end   = lsu_owner_v && core_i.lsu_resp_valid;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    lsu_owner_pc <= '0;
    lsu_owner_v  <= 1'b0;
  end else begin
    if (lsu_end)   lsu_owner_v  <= 1'b0;
    if (lsu_start) begin
      lsu_owner_pc <= pc_id;
      lsu_owner_v  <= 1'b1;
    end
  end
end

// =============================================================================
// [13] µFSM owner tracking: Multiplier and Divider
//
// Shared signals from the fast multiplier/divider unit.
// mult_start / div_start: unit is in initial state and operation begins
// mul_done / div_done:    owning instruction's valid_o fires
//
// NOTE: verify state encodings in your Ibex version:
//   mult_state ALBL == 2'd0
//   div_state  IDLE == 3'd0
// =============================================================================
logic [31:0] mul_owner_pc;
logic        mul_owner_v;
logic [31:0] div_owner_pc;
logic        div_owner_v;

wire valid      = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.valid_o;
wire [2:0] div_state  =
  core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q;
wire [1:0] mult_state =
  core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q;
wire mult_en    = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i;
wire div_en     = core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i;

wire mult_start = mult_en && (mult_state == 2'd0) && !mul_owner_v; // ALBL
wire div_start  = div_en  && (div_state  == 3'd0) && !div_owner_v; // MD_IDLE

wire mul_done   = mul_owner_v && valid;
wire div_done   = div_owner_v && valid;

always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    mul_owner_pc <= '0;
    mul_owner_v  <= 1'b0;
    div_owner_pc <= '0;
    div_owner_v  <= 1'b0;
  end else begin
    // Clear on finish
    if (mul_done) mul_owner_v <= 1'b0;
    if (div_done) div_owner_v <= 1'b0;

    // Capture new owner (guard: only one can start per cycle)
    if (mult_start && !div_start) begin
      mul_owner_pc <= pc_id;
      mul_owner_v  <= 1'b1;
    end
    if (div_start && !mult_start) begin
      div_owner_pc <= pc_id;
      div_owner_v  <= 1'b1;
    end
  end
end
