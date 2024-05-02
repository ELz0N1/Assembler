.macro check_grep_c %label
  andi t0, s6, 2
  beqz t0, check_grep_c_end
  addi s7, s7, 1
  j %label
check_grep_c_end:
.end_macro



.macro check_grep_n
  andi t0, s6, 4
  beqz t0, check_grep_n_end
  mv a0, s4
  syscall 1
  li a0, ':'
  printch
check_grep_n_end:
.end_macro



grep:
  push4 ra, s1, s2, s3
  push4 s4, s5, s6, s7 
  mv s1, a0  #  array
  mv s2, a1  #  size
  mv s3, a2  #  str
  li s4, 1  #  index
  mv s6, a3  #  flags
  li s7, 0  #  count
  
grep_loop:
  lw s5, 0(s1)
  mv a0, s5
  mv a1, s3
  andi a2, s6, 1
  call strstr
  beqz a0, grep_not_found
  andi t0, s6, 8
  bnez t0, grep_loop_end
  check_grep_c grep_loop_end
  check_grep_n
  mv a0, s5
  syscall 4
  newline
  j grep_loop_end
  
grep_not_found:
  andi t0, s6, 8
  beqz t0, grep_loop_end
  check_grep_c grep_loop_end
  check_grep_n
  mv a0, s5
  syscall 4
  newline
  
grep_loop_end:
  addi s1, s1, 4
  addi s4, s4, 1
  ble s4, s2, grep_loop
  andi t0, s6, 2
  beqz t0, grep_end
  mv a0, s7
  syscall 1
  newline
  
grep_end:
  pop4 s4, s5, s6, s7
  pop4 ra, s1, s2, s3
  ret
