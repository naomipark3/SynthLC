
# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.if_stage_i.pc_id_o}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.instr_valid_id}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.id_stage_i.id_fsm_q}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set S2 {core_i.load_store_unit_i.ls_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.if_stage_i.pc_id_o}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.id_stage_i.controller_i.ctrl_fsm_cs}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.instr_valid_id}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.id_stage_i.id_fsm_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.gen_mult_fast.mult_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.mult_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.md_state_q}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"

# curly brace to avoid string interpolcation
set S1 {core_i.load_store_unit_i.ls_fsm_cs}
set S2 {core_i.ex_block_i.gen_multdiv_fast.multdiv_i.div_en_i}
set s1_exist [catch { get_signal_info -logic $S1 } type1]
if { $s1_exist == 1 } {
    puts "fail to find $S1"
}
set s2_exist [catch {get_signal_info -logic $S2 } type2] 
if { $s2_exist == 1 } {
    puts "fail to find $S2"
}
if { $s1_exist == 0 && $s2_exist == 0 } {
  set path [graph -shortest_path -from  $S1 -to $S2 -type register]  
  puts "$S1 $S2, $path"
  puts "$type1 $type2"
  set len [llength $path]
  if { $type1 == "flop" && $type2 == "flop" && $len == 2 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "flop" && $type2 == "wire" && $len <= 3 } {
        puts "ADD $S1 $S2"
  }
  if { $type1 == "wire" && $type2 == "wire" } {
      if { $len == 2 } {
            puts "ADD(ww2) $S1 $S2"
        } elseif { $len == 3 } {
            puts "ADD(ww) $S1 $S2"
        } 
  }
  if { $type1 == "wire" && $type2 == "flop" } {
    set ele2 [lindex $path 1]
    set ele3 [lindex $path 2]
    if { $len == 2 } {
        puts "ADD $S1 $S2"
    }
  }
} 
puts "--------------------------------"
