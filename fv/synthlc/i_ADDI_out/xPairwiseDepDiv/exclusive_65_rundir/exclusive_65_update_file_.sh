
if [ -f "./synthlc/i_ADDI_out/xPairwiseDepDiv/out/exclusive_65.sv" ] && [ -f "./ibex_fv/ibex_topsim.sv" ]; then
    { head -n -1 "./ibex_fv/ibex_topsim.sv"; cat "./ibex_fv/ibex_header_fv.sv"; cat "./synthlc/i_ADDI_out/xPairwiseDepDiv/out/exclusive_65.sv" ; echo "" ; tail -n 1 "./ibex_fv/ibex_topsim.sv"; } > "./synthlc/i_ADDI_out/xPairwiseDepDiv/exclusive_65_top.sv" #"/_top.sv"
else 
    echo "[RUN_JG] no property at ./synthlc/i_ADDI_out/xPairwiseDepDiv/out/exclusive_65.sv is found or no ./ibex_fv/ibex_topsim.sv"
    exit 0
fi

