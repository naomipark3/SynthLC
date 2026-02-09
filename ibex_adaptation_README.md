RTL2MμPATH Setup for Ibex: Complete Walkthrough
Overview
RTL2MμPATH is a formal verification tool that extracts microarchitectural execution paths from processor RTL to detect side-channel vulnerabilities. Originally designed for the CVA6/Ariane RISC-V core, we adapted it to work with the Ibex RISC-V core. This required understanding the tool's requirements, creating Ibex-specific metadata, and fixing extensive hardcoded assumptions throughout the codebase.

Phase 0: Understanding What RTL2MμPATH Needs
What the tool does: RTL2MμPATH uses formal verification (JasperGold) to prove that when you execute an instruction, it visits a specific sequence of internal processor states. The key insight: instruction paths can diverge based on operand values (e.g., branch taken vs. not taken, fast vs. slow division), which creates timing side-channels.
What metadata it needs:
1. Pipeline Control Registers (PCRs) - The internal signals that track an instruction's progress through the pipeline
2. Microarchitectural FSM (μFSM) - The state machine that describes how instructions move through pipeline stages
3. Idle state definition - How to detect when no instruction is executing
4. Retire signal - How to detect when an instruction completes
5. Instruction subset - A minimal set of instructions covering all distinct path shapes
Why this metadata matters: The tool needs to know which signals to monitor (PCRs) and how to interpret them (μFSM states) to track an instruction from start to finish. Without this, it can't distinguish between "instruction A took 1 cycle" vs. "instruction A took 3 cycles."

Phase 1: Initial Environment Setup
Step 1.1: Access Stanford's Caddy Server
What we did: Connected to caddy12 (later switched to caddy06) instead of running locally.
Why:
* JasperGold is a commercial Cadence formal verification tool, not installable on a Mac
* Stanford EE/CS departments license JasperGold on shared compute servers
* The SynthLC repo was designed for a Linux (CentOS/RHEL) environment with yum package manager

Step 1.2: Load JasperGold Module
module load jaspergold/latest
which jg  # Confirms JasperGold is now in PATH
Why:
* The tool chain expects the jg command to be available
* Note: The installation docs mention jc, but that's likely a typo - the actual command is jg

Step 1.3: Install Python Dependencies
cd ~/SynthLC/fv
mkdir pyenv
python3 -m venv pyenv/
source pyenv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install matplotlib pandas networkx cvc5 numpy
Why:
* RTL2MμPATH's Python scripts use networkx for graph algorithms (dataflow graphs)
* cvc5 is an SMT solver used for constraint solving in formal verification
* pandas/matplotlib for data analysis and visualization of results

Step 1.4: Install Graphviz
yum install graphviz
which dot  # Confirms dot is available
Why:
* The tool generates .dot files to visualize execution paths
* Graphviz's dot command converts these to PDFs/PNGs

Phase 2: Creating Ibex-Specific Files
The SynthLC repo contains hardcoded files for CVA6. We needed to create parallel Ibex versions.
Step 2.1: Top-Level FV Wrapper (ibex_topsim.sv)
What we did: Created a SystemVerilog testbench that instantiates ibex_core with symbolic inputs.
Key components:
// Symbolic free variable for instruction memory
logic [31:0] data_rdata_i;  // No driver - this is our symbolic input

// Black-box the instruction fetch stage
initial $JG_BLACK_BOX("ibex_core.if_stage_i");

// Instantiate the core
ibex_core #(
  .PMPEnable(0),
  .PMPGranularity(0),
  .WritebackStage(0),      // Important: no WB stage
  .BranchTargetALU(0),     // Important: branches always multi-cycle
  .RV32M(ibex_pkg::RV32MFast)  // Fast multiply, slow divide
) u_ibex_core (
  // Connect all ports...
);
Why each design choice:
* Symbolic data_rdata_i: JasperGold treats this as a free variable, allowing it to explore all possible instruction encodings
* Black-box IF stage: We don't care about instruction fetch timing for μPATH analysis - we only care about decode through retire
* Specific parameters: These match the simple_system configuration and affect which registers exist and how the pipeline behaves

Step 2.2: Formal Assumptions (ibex_header_fv.sv)
What we did: Created SVA (SystemVerilog Assertions) assumptions to constrain the formal verification.
Key assumptions:
// No instruction fetch errors
assume property (ibex_core.instr_fetch_err == 0);

// No data memory errors  
assume property (ibex_core.lsu_load_err_i == 0);

// No interrupts
assume property (ibex_core.irq_software_i == 0);
assume property (ibex_core.irq_external_i == 0);
// ... all interrupt sources disabled
Why these assumptions:
* We want to analyze instruction execution timing in the "happy path"
* Exceptions, interrupts, and memory errors create complex control flow that obscures the μPATH we're trying to analyze
* These assumptions prune the state space to make formal verification tractable

Step 2.3: HDL File List (ibex_hdl.f.template)
What we did: Listed all RTL source files and include paths.
+incdir+/home/ngpark/ibex/rtl
+incdir+/home/ngpark/ibex/dv/uvm/core_ibex/common/prim/rtl
+incdir+/home/ngpark/ibex/vendor/lowrisc_ip/ip/prim/rtl
+incdir+/home/ngpark/ibex/vendor/lowrisc_ip/dv/sv/dv_utils

/home/ngpark/ibex/rtl/ibex_pkg.sv
/home/ngpark/ibex/rtl/ibex_alu.sv
/home/ngpark/ibex/rtl/ibex_core.sv
# ... all dependent files
Why:
* JasperGold needs to know where to find all SystemVerilog files and package imports
* Ibex uses the prim_* library from lowRISC, so we need those include paths
* The template has a TOPMOD placeholder that gets replaced by the setup script

Step 2.4: μFSM Annotation (annotation_pcr_ufsms_ibex.txt)
What we did: Documented our PCRs and μFSM in a structured text format.
Example entries:
PCR: ibex_core.id_stage_i.instr_rdata_id_o[31:0]
PCR: ibex_core.id_stage_i.pc_id_o[31:0]
PCR: ibex_core.id_stage_i.controller_i.ctrl_fsm_cs[3:0]
PCR: ibex_core.id_stage_i.branch_set_raw_q

UFSM_STATE: S0 = (ctrl_fsm_cs == DECODE && !id_fsm_q)
UFSM_STATE: S1 = (ctrl_fsm_cs == DECODE && id_fsm_q)
UFSM_STATE: FLUSH = (ctrl_fsm_cs == FLUSH)
UFSM_STATE: RETIRE = (ctrl_fsm_cs == DECODE && instr_id_done_o)
Why this structure:
* The tool's Python scripts parse this file to generate SVA properties
* Each PCR gets monitored throughout the instruction's execution
* The μFSM states define the "waypoints" an instruction visits

Step 2.5: Setup Script (setup_scripts_ibex.sh)
What we did: Created a bash script to generate the final configuration files.
What it generates:
1. hdl.f.test - Expands TOPMOD in the template
2. jg_base.tcl.test - JasperGold TCL script with elaborate -bbox_m {ibex_if_stage}
3. src/topsim.sv - Symlink to our Ibex wrapper
4. src/header_fv.sv - Symlink to our Ibex assumptions
5. annotation_pcr_ufsms.txt - Copy of our annotation
Why a script:
* The SynthLC repo expects these specific filenames in specific locations
* The script ensures consistency and makes it reproducible

Step 2.6: Environment Variables (env_ibex.sh)
What we did: Defined Ibex-specific signal names.
export CLK="clk_i"
export TOPMOD="ibex_fv"
export RESET="!rst_ni"
Why:
* Python scripts use these environment variables to construct signal paths
* Ibex uses active-low reset (rst_ni), so we need !rst_ni in assertions
* The HB_template.py file gets these values substituted in

Phase 3: Sanity Check (Step 00-01)
Step 3.1: Run Setup Script
cd ~/SynthLC/fv
cp -r ~/path/to/ibex_fv .
chmod +x ibex_fv/setup_scripts_ibex.sh
./ibex_fv/setup_scripts_ibex.sh
cd synthlc && source ../ibex_fv/env_ibex.sh && cd ../
What this does:
* Generates all the config files in the expected locations
* Sets environment variables
* Creates symlinks to our Ibex-specific files

Step 3.2: OS Override Flag
Problem encountered: JasperGold 2023.12 doesn't officially support Rocky Linux 8.10.
Solution: Edit RUN_JG.sh to add -allow_unsupported_OS:
# Original line ~197:
jg -no_gui -fpv $TCLF -proj $PROJ

# Modified:
jg -allow_unsupported_OS -no_gui -fpv $TCLF -proj $PROJ
Why: The tool works fine on Rocky Linux, Cadence just hasn't officially validated it.


Step 3.3: Black-Box prim_lfsr
Problem encountered: JasperGold couldn't elaborate prim_lfsr (used by dummy instruction insertion).
Solution: Add to black-box list in jg_base.tcl.test:
elaborate -bbox_m {ibex_if_stage} -bbox_m {prim_lfsr} -top $TOPMOD
Why:
* We don't care about dummy instruction insertion logic for μPATH analysis
* Black-boxing tells JasperGold "treat this as an uninterpreted module"
* This is safe because we constrain ibex_core.instr_fetch_err == 0 anyway

Step 3.4: Run Sanity Elaboration
mkdir -p xSanity && touch xSanity/xSanity.sv
./RUN_JG.sh -j xSanity -s xSanity/xSanity.sv -g 0
Expected output:
Elaboration successful
prove -property noDeadEnd     # PROVEN
prove -property noConflict    # PROVEN
prove -property :live         # COVERED in 1 cycle
CHECK ASSUMPTION CONFLICT result: no_conflict
What this validates:
* All RTL files parse correctly
* The formal environment is sound (no conflicting assumptions)
* The design can make forward progress (:live is coverable)

Phase 4: Performance Location Enumeration (Step 02)
Step 4.1: Understanding Performance Locations
What is a performance location (PL)? A PL is a specific combination of μFSM state and cycle count. For example:
* id_fsm_s1 = "1st cycle in S1 state"
* id_fsm_s2 = "2nd cycle in S1 state"
* id_ctrl_s3 = "3rd cycle in any DECODE state"
Why do we need these?
* RTL2MμPATH needs to know all possible "waypoints" an instruction can visit
* Each instruction's path is a sequence of PLs: e.g., ADDI might be [id_fsm_s2] (one cycle), while DIV might be [id_fsm_s2, id_fsm_s3, id_fsm_s4, ...] (many cycles)

Step 4.2: Run the Enumeration
cd synthlc
./S02_create_DUV_PL_DFG.sh
What this script does:
1. Reads annotation_pcr_ufsms.txt to get μFSM state definitions
2. Uses JasperGold's BMC (bounded model checking) to find reachable PLs
3. For each μFSM state, determines maximum cycle count before transitioning
4. Generates MYGRAPH.py with the PL list
Output for Ibex:
PLNAME = [
    'id_ctrl_s1', 'id_ctrl_s2', 'id_ctrl_s3', 
    'id_ctrl_s4', 'id_ctrl_s5', 'id_ctrl_s6',
    'id_fsm_s1', 'id_fsm_s2', 'id_fsm_s3'
]
What this means:
* id_ctrl_s1 through id_ctrl_s6: The core can stay in any DECODE state for up to 6 cycles (likely for slow division)
* id_fsm_s1 through id_fsm_s3: Specific substates for first-cycle, second-cycle, multi-cycle execution

Step 4.3: Dataflow Graph Generation
What the DFG represents: A directed graph where:
* Nodes = performance locations (PLs)
* Edges = possible transitions between PLs
Why we need it:
* Tells us which paths are theoretically reachable
* Used to prune the search space in later analysis
Generated files:
* PLgraph.pdf - Visual representation of the graph
* Graph data structures in MYGRAPH.py

Phase 5: Per-Instruction Analysis (Step 03)
This is where we hit the major compatibility issues.
Problem 1: Hardcoded CVA6 Performance Locations
What we found: Five Python template files had hardcoded lists of CVA6 PLs:
# In various templates:
PLNAME = ['scb_0_s12', 'issue_s1', 'serdiv_unit_divide_s1', ...]
Files needing modification:
1. src/HB_template.py.template - Path property generation
2. src/APerflocDef.py.template - Performance location definitions
3. src/PairwiseDepDef.py.template - Pairwise dependency checking
4. src/MYGRAPH_init.py.template - Graph initialization
5. src/MYGRAPH.py - The generated output from S02
Solution: Replace all hardcoded lists with Ibex's 9 PLs:
PLNAME = ['id_ctrl_s1', 'id_ctrl_s2', 'id_ctrl_s3', 
          'id_ctrl_s4', 'id_ctrl_s5', 'id_ctrl_s6',
          'id_fsm_s1', 'id_fsm_s2', 'id_fsm_s3']
Why this was needed:
* The templates generate SVA properties for each PL
* They also create Python dictionaries indexed by PL names
* Mismatched PL names cause KeyError exceptions

Problem 2: Module-Level Variable Scoping
What went wrong: When running analysis for ADDI, we got:
KeyError: 'id_fsm_s2'
Root cause:
# In S03_01_create_sva_HB.py:
from MYGRAPH import *

# This imports PLNAME, but then later in the script:
import MYGRAPH
# ... code that expects MYGRAPH.PLNAME to exist
The issue:
* from MYGRAPH import * brings PLNAME into the global namespace
* But if MYGRAPH.py was imported before being regenerated, Python's import cache still has the old CVA6 version
* Later code that references MYGRAPH.PLNAME gets the old cached version
Solution: After running S02 (which regenerates MYGRAPH.py), manually update it:
# Edit src/MYGRAPH.py to replace CVA6 PLs with Ibex PLs
Better solution for production: Add importlib.reload(MYGRAPH) after import, or don't mix from X import * with import X.

Problem 3: Signal Hierarchy Paths
What we had to fix:
# CVA6 (6-stage pipeline):
'issue_s8': "ariane_core.issue_stage_i.scoreboard_i.issue_instr_o"

# Ibex (2-stage pipeline):
'id_fsm_s2': "ibex_core.id_stage_i.controller_i.id_fsm_q"
Why this matters:
* The tool generates properties like assume(issue_s8 == 1'b1)
* If the signal path is wrong, JasperGold can't find the signal and the proof fails

Problem 4: Instruction Encoding
What we had to change:
# CVA6 uses RV64I:
'ADDI': "32'h00010093"  # addi x1, x2, 0

# Ibex uses RV32I:
'ADDI': "32'h00010093"  # Same encoding, but 32-bit interpretation
Also had to disable RV64-specific instructions:
* Memory instructions with 64-bit addressing modes
* RV64I-specific opcodes

Phase 6: Successful ADDI Analysis
Step 6.1: Run the Analysis
cd synthlc
./run_an_instn_demo.sh ADDI.sv
What happens:
1. S03_01: Generates SVA properties for happens-before relationships
2. S03_02: Generates SVA for performance location coverage
3. S03_03: Invokes JasperGold to prove properties
4. S03_04-10: Analyzes results, builds execution paths, generates reports
Step 6.2: Interpret Results
Key output:
Step 10: ADDI execution path:
  id_fsm_s2 (1 cycle)
What this means:
* ADDI visits exactly one performance location: id_fsm_s2
* It stays there for 1 cycle
* This is correct for a simple ALU instruction in Ibex's pipeline
Why this is important:
* This is the baseline for single-cycle instructions
* Instructions like BEQ (branch) or DIV (division) will show different paths
* Divergence in paths based on operand values = potential side-channel
* 
Step 6.3: Generated Artifacts
Output directory structure:

synthlc/i_ADDI_out/
├── xCoverAPerflocDiv/
│   ├── cover_individual.txt    # PLs this instruction can visit
│   └── always_reach.txt         # PLs this instruction always visits
├── xPerfLocSubsetDiv/
│   └── reachable_set.txt        # Set of reachable PLs
├── xPerfLocCycleCount/
│   └── max_cycle_per_pl.txt     # Format: "PL_name,cycle_count"
├── xPairwiseDepDiv/             # Dependency analysis
├── xEnumCycleCnt/               # Cycle enumeration results
└── xSummarize/                  # Aggregated results
Key results for ADDI:


bash
$ cat i_ADDI_out/xCoverAPerflocDiv/cover_individual.txt
id_fsm_s2

$ cat i_ADDI_out/xPerfLocCycleCount/max_cycle_per_pl.txt
id_fsm_s2,1
Interpretation:
* ADDI visits exactly one PL: id_fsm_s2 (valid instruction, first cycle)
* It stays there for 1 cycle total
* This confirms single-cycle ALU execution 
What you can do with these:
* Compare ADDI's reachable set against BEQ (should show branch-dependent paths)
* Compare DIV's cycle counts (should show variable length execution)
* Identify which PCRs create timing divergence by comparing across instructions

Important Notes
The PL annotations in header_nia.sv were autogenerated by step 02, which ran JasperGold without the NI constraints. It found 3 reachable states for the id_fsm μFSM by cross-producing the two tracking signals. So, id_fsm_3 is the state where a multi-cycle instruction like DIV or LW is continuing execution. Our NI constraint NO_INSTN_INTERFERENCE_2: first |=> always !(instr_valid_id) makes id_fsm_s3 unreachable under NI analysis, since it requires instr_valid_id=1 after the first cycle. This is fine for ADDI but will be a problem for multi-cycle instructions. 

I believe that the over-approximation from id_fsm_3 is safe (extra PLs mean more pairs to check in steps 2-4; worst case is wasted computation on spurious PLs but we won’t get incorrect μPATHs or miss real paths). The real blocker will be the NI constraint, not the annotation. We’ll have to fix NO_INSTN_INTERFERENCE_2 regardless. 
