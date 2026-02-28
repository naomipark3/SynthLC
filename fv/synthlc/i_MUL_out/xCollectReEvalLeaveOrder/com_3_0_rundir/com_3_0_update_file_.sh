
if [ -f "./synthlc/i_MUL_out/xCollectReEvalLeaveOrder/out_complete_2_setcover/com_3_0.sv" ] && [ -f "./ibex_fv/ibex_topsim.sv" ]; then
    { head -n -1 "./ibex_fv/ibex_topsim.sv"; cat "./ibex_fv/ibex_header_fv.sv"; cat "./synthlc/i_MUL_out/xCollectReEvalLeaveOrder/out_complete_2_setcover/com_3_0.sv" ; echo "" ; tail -n 1 "./ibex_fv/ibex_topsim.sv"; } > "./synthlc/i_MUL_out/xCollectReEvalLeaveOrder/com_3_0_top.sv" #"/_top.sv"
else 
    echo "[RUN_JG] no property at ./synthlc/i_MUL_out/xCollectReEvalLeaveOrder/out_complete_2_setcover/com_3_0.sv is found or no ./ibex_fv/ibex_topsim.sv"
    exit 0
fi

