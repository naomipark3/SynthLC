# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2023.12
# platform  : Linux 4.18.0-553.89.1.el8_10.x86_64
# version   : 2023.12p001 64 bits
# build date: 2024.01.23 16:09:24 UTC
# ----------------------------------------
# started   : 2026-03-01 05:35:53 PST
# hostname  : caddy12.stanford.edu.(none)
# pid       : 3981250
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:45945' '-nowindow' '-style' 'windows' '-data' 'AAACAHicvY9NTsMwFIS/gECIBWLJGZCgoVUQiy5YwK6IPwmWESoFUkVNRAItbOAYHI+bhC+uusgFsOWxPW/mjR0Bw6+maQhj/VPYZcQFN5yLl9y5wx4JfU6IOWXMA4/kZJ7ipS/6Xe4MI7qjva91mevvzg4bK/NKsuna58Cc3FkwJ+WNGZVYOgteqZn4itQX3qreUT2TT3lWk8lsyTypffc85ZCe7g81NS/2HHvPVI+4Fws9tcyCKzMzu8/FyoQzVylm9ul5XujMVVeBmejth5maUIcabJtc2qMwF37+IXvqr1tHFWqFSW3t2HfEDAIeBUzkBwETmXb8ASJOSvQ=' '-proj' '/home/users/cheriek/Documents/Formal_Method/final_project/SynthLC/fv/synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222_jgsession_26-03-01-05_35_51/sessionLogs/session_0' '-init' '-hidden' '/home/users/cheriek/Documents/Formal_Method/final_project/SynthLC/fv/synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222_jgsession_26-03-01-05_35_51/.tmp/.initCmds.tcl' './synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222_.tcl'
# Run JG with a TCl file: jg jg_test.tcl
set assert_report_incompletes 1
set RTL_DIR /home/users/cheriek/Documents/Formal_Method/final_project/ibex
set SRCDIR /home/users/cheriek/Documents/Formal_Method/final_project/ibex/rtl

############
set FPV 1
set REACH 0
set CUSTOMTCL 0
############
exec ./synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222_update_file_.sh
# Analyze RTL files
analyze -sv09 -f ./synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222_hdls.f -y $SRCDIR +incdir+$SRCDIR

if {$REACH == 1} {
    puts "test bboxing mfpt" 
    #elaborate -bbox_m  {miss_prediction_fix_table} -bbox_m {reorderbuf}
    #elaborate
    source reach_collect.tcl
}
if {$FPV == 1} {
    puts "fpv" 
    # Elaborates
    #elaborate -bbox_m {wt_cache_subsystem} -bbox_m {ibex_if_stage}
    #puts "multiplier no-bbox"
    elaborate -top ibex_fv -bbox_m {ibex_if_stage} -bbox_m {prim_lfsr}
    #elaborate -bbox_m {ibex_if_stage}
    #stopat -env {issue_stage_i.i_scoreboard.mem_n[0].sbe.is_compressed}  
    #elaborate


    # Initialization
    # Clock specification
    clock clk_i
    # -both_edges: ridecore 
    reset !rst_ni
    set_proofgrid_per_engine_max_jobs 10
    set_proofgrid_max_jobs 30


    #SOURCE_TCL
    # assume -enable {.*ASSUME_W_R} -regexp
    # assume -disable {.*ASSUME_R_W} -regexp

    task -create mytask -copy_assumes  -copy {.*C_222.*}  -regexp
    task -set mytask

    if { $CUSTOMTCL == 1 } {
        puts "=========CUSTOMTCL========="

        #CUSTOMTCL
        
        puts "=========EXIT CUSTOMTCL========="
        exit
        
    } 
    
    puts "=============================================================="
    puts "CHECK ASSUMPTION...."
    puts "=============================================================="
    set CA 0
    #ASSUMPTION
    #
    set_prove_time_limit 15m
    #SETPROVETIME
    set_prove_per_property_time_limit 5m 

    set ls [get_property_list -task mytask -include {type {assert cover} }]
    if { [llength $ls] > 10 } { 
        set_prove_time_limit 25m 
        puts "PROVEN TIME 25min" }  

    if { $CA == 1 } { 
        #set_prove_time_limit 10m
        set CONFLICT [check_assumptions -task mytask -conflict]
        puts "=============================================================="
        puts "CHECK ASSUMPTION CONFLICT result? $CONFLICT"
        puts "=============================================================="
    }  else {
        puts "AUTOPROVE:" 
        #set_prove_time_limit 1h
        #set_prove_per_property_time_limit 1h
        puts "=================================================="
        puts " PROVE TIME LIMIT"
        puts [get_prove_time_limit]     
        #puts [get_prove_per_property_time_limit]
        puts "=================================================="
        set_engine_mode {K C Tri I N AD AM Hp B}

        prove -task mytask
        #prove -all
    }
    
    puts "END"
    report -task mytask -csv -results -file "./synthlc/i_LW_out/xPairwiseDepDiv/exclusive_222.csv" -force
    exit
}
