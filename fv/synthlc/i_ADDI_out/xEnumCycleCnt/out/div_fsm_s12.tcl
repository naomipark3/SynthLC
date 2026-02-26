set_prove_time_limit 10m
set itm {div_fsm_s12}
set min {1}
set max {70}
set cnt {1}
while 1 {
  if { $cnt > $max } {
    break
  } 
  set CMD "cover -name CS_$itm\_$cnt {@(posedge clk_i) !$itm ##1 $itm \[*$cnt\] ##1 !$itm }"
  puts $CMD
  try { 
    eval $CMD
  } on error {} {
    puts "ERROR: $CMD"
    break
  } 
  set CMD "prove -property {CS_$itm\_$cnt}"
  eval $CMD
  set cnt [expr {$cnt + 1}]
}
report -csv -file /home/users/ngpark/SynthLC/fv/synthlc/i_ADDI_out/xEnumCycleCnt/div_fsm_s12.csv 
