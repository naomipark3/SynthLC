
if [ -f "./synthlc/i_LW_out/xPerfLocSubsetDiv/covertest/coverset_279.sv" ] && [ -f "./ibex_fv/ibex_topsim.sv" ]; then
    { head -n -1 "./ibex_fv/ibex_topsim.sv"; cat "./ibex_fv/ibex_header_fv.sv"; cat "./synthlc/i_LW_out/xPerfLocSubsetDiv/covertest/coverset_279.sv" ; echo "" ; tail -n 1 "./ibex_fv/ibex_topsim.sv"; } > "./synthlc/i_LW_out/xPerfLocSubsetDiv/coverset_279_top.sv" #"/_top.sv"
else 
    echo "[RUN_JG] no property at ./synthlc/i_LW_out/xPerfLocSubsetDiv/covertest/coverset_279.sv is found or no ./ibex_fv/ibex_topsim.sv"
    exit 0
fi

