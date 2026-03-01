
if [ -f "./synthlc/i_MUL_out/xPairwiseDepDiv/out/nunv_anytwo_166.sv" ] && [ -f "./ibex_fv/ibex_topsim.sv" ]; then
    { head -n -1 "./ibex_fv/ibex_topsim.sv"; cat "./ibex_fv/ibex_header_fv.sv"; cat "./synthlc/i_MUL_out/xPairwiseDepDiv/out/nunv_anytwo_166.sv" ; echo "" ; tail -n 1 "./ibex_fv/ibex_topsim.sv"; } > "./synthlc/i_MUL_out/xPairwiseDepDiv/nunv_anytwo_166_top.sv" #"/_top.sv"
else 
    echo "[RUN_JG] no property at ./synthlc/i_MUL_out/xPairwiseDepDiv/out/nunv_anytwo_166.sv is found or no ./ibex_fv/ibex_topsim.sv"
    exit 0
fi

