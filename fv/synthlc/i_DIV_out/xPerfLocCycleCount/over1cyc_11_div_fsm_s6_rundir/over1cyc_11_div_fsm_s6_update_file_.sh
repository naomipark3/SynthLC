
if [ -f "./synthlc/i_DIV_out/xPerfLocCycleCount/out2/over1cyc_11_div_fsm_s6.sv" ] && [ -f "./ibex_fv/ibex_topsim.sv" ]; then
    { head -n -1 "./ibex_fv/ibex_topsim.sv"; cat "./ibex_fv/ibex_header_fv.sv"; cat "./synthlc/i_DIV_out/xPerfLocCycleCount/out2/over1cyc_11_div_fsm_s6.sv" ; echo "" ; tail -n 1 "./ibex_fv/ibex_topsim.sv"; } > "./synthlc/i_DIV_out/xPerfLocCycleCount/over1cyc_11_div_fsm_s6_top.sv" #"/_top.sv"
else 
    echo "[RUN_JG] no property at ./synthlc/i_DIV_out/xPerfLocCycleCount/out2/over1cyc_11_div_fsm_s6.sv is found or no ./ibex_fv/ibex_topsim.sv"
    exit 0
fi

