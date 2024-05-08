.data
  whitespaces: .asciz " \t\n"
  
  
.text
words_count:
  push4 ra, s1, s2, s3
  mv s1, a0
  la s2, whitespaces
  li s3, -1 # ans
  
words_count_loop:
  addi s3, s3, 1
  lb t0, 0(s1)
  mv a0, t0
  beqz t0, words_count_end
  mv a0, s1
  mv a1, s2
  call strspan
  add s1, s1, a0
  lb t0, 0(s1)
  beqz t0, words_count_end
  mv a0, s1
  mv a1, s2
  call strcspan
  add s1, s1, a0
  bnez a0, words_count_loop
  
words_count_end:
  mv a0, s3
  pop4 ra, s1, s2, s3
  ret



max_line_length:
  push5 ra, s1, s2, s3, s4
  mv s1, a0 # array
  mv s2, a1 # size
  li s4, '\0'
  li s3, 0
  
max_line_length_loop:
  lw a0, 0(s1)
  mv a1, s4
  call strcspan
  addi s1, s1, 4
  blt a0, s3, nomaxlengh
  mv s3, a0
  
nomaxlengh:
  addi s2, s2, -1
  bnez s2, max_line_length_loop
  mv a0, s3
  pop5 ra, s1, s2, s3, s4
  ret



wc:
  push5 ra, s1, s2, s3, s4
  push2 s5, s6
  bnez a2, not_change_flags
  li a2, 14
not_change_flags:
  mv s1, a0 # str
  mv s2, a1 # bytes
  mv s3, a2 # flags
  mv a0, s1
  call words_count 
  mv s6, a0 # words
  mv a0, s1
  call split_lines
  mv s4, a1 # lines
  mv s5, a0 # array
  andi t0, s3, 8
  beqz t0, check_wc_w
  mv a0, s4
  syscall 1
  li a0, ' '
  printch
  
check_wc_w:
  andi t0, s3, 4
  beqz t0, check_wc_c
  mv a0, s6
  syscall 1
  li a0, ' '
  printch
  
check_wc_c:
  andi t0, s3, 2
  beqz t0, check_wc_L
  mv a0, s2
  syscall 1
  li a0, ' '
  printch
  
check_wc_L:
  andi t0, s3, 1
  beqz t0, wc_end
  mv a0, s5
  mv a1, s4
  call max_line_length
  syscall 1
  
wc_end:
  pop2 s5, s6
  pop5 ra, s1, s2, s3, s4
  ret
