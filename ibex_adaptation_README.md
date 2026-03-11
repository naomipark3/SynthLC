RTL2MμPATH Setup for Ibex:
We will walk through the comprehensive setup (i.e. steps 01, 02, and 03 for running RTL2M\muPATH on Ibex):
ngpark@caddy15:~/SynthLC$ cd fv/

Set up environment:
ngpark@caddy15:~/SynthLC/fv$ source pyenv/bin/activate
module load jaspergold/latest
export TOPMOD="ibex_fv"
export CLK="clk_i"
export RESET='!rst_ni'

#Step 01 must be rerun each time:
#From SynthLC/fv:
./ibex_fv/setup_scripts_ibex.sh
sed -i '18s/^\(\s*\)elaborate\s*$/\1#elaborate/' jg_base.tcl.test
sed -i '26s/elaborate -bbox_m {ibex_if_stage}/elaborate -top ibex_fv -bbox_m {ibex_if_stage} -bbox_m {prim_lfsr}/' jg_base.tcl.test
grep -n "elaborate" jg_base.tcl.test

**Should now read:
ngpark@caddy15:~/SynthLC/fv$ grep -n "elaborate" jg_base.tcl.test
17:    #elaborate -bbox_m  {miss_prediction_fix_table} -bbox_m {reorderbuf}
18:    #elaborate
24:    #elaborate -bbox_m {wt_cache_subsystem} -bbox_m {ibex_if_stage}
26:    elaborate -top ibex_fv -bbox_m {ibex_if_stage} -bbox_m {prim_lfsr}
27:    #elaborate -bbox_m {ibex_if_stage}
29:    #elaborate

#Sanity check
mkdir -p xSanity && touch xSanity/xSanity.sv

#Now, run ./RUN_JG.sh as follows:
./RUN_JG.sh -j xSanity -s xSanity/xSanity.sv -g 0

#Step 02 must also be rerun:
cd ~/SynthLC/fv

#Clean any old outputs
rm -f xDUVPLs/perf_loc_top.sv xDUVPLs/perf_loc_.tcl
rm -rf xDUVPLs/xDUVPLs_rundir/ xDUVPLs/perf_loc_rundir/
rm -f xDUVPLs/reachable_duvpls.sv xDUVPLs/sig_width.txt
rm -f xDUVPLs/perf_loc.sv xDUVPLs/perf_loc.csv xDUVPLs/get_sig_width.tcl
rm -f header_ia.sv header_nia.sv header_ia_subset.sv

#Run PL enumeration
./run_duvpls.sh
#This runs gen.py 3 times: gen → gen_s2 → pp
#Produces xDUVPLs/reachable_duvpls.sv and xDUVPLs/perfloc_signals.txt
#Then concatenates PLs into header_ia.sv, header_nia.sv, header_ia_subset.sv

#Verify output
cat xDUVPLs/perfloc_signals.txt

#Run DFG generation (bypass mode uses pre-loaded file — fine for now)
#If changes were made to the header/annotation files, need to:
#in SynthLC/fv/synthlc/xGenPerfLocDfgDiv:
rm -rf tmp_rundir

#Now, execute run_gendfg.sh (can run without BYPASS=0 if you DON’T want to overwrite the graph)
BYPASS=0 ./run_gendfg.sh

#Check output exists:
cat synthlc/xGenPerfLocDfgDiv/dfg_e.txt
cd ~/SynthLC/fv/synthlc/xGenPerfLocDfgDiv
#**need to copy the newly generated dfg_e.0 to dfg_e.txt, otherwise it will use a stale version
cp dfg_e.0 dfg_e.txt 
cp dfg_e.0 expected_output/dfg_e.txt

#To use the same DFG as before:
./run_gendfg.sh 

#Step 03: we can finally run RTL2M\muPATH on Ibex:
#from SynthLC/fv/synthlc:
./run_an_instn_demo.sh ADDI.sv

**NOTE: The ibex_fv folder contains our Ibex-specific formal environment, annotation file, and header. The ibex_header_fv.sv is the "Original" header described in our report, and ibex_header_fv_restricted.sv is the "Restricted" header described in the report.
