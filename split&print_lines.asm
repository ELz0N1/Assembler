split_lines:
  push5 ra, s1, s2, s3, s4
  mv s1, a0  #  string
  call count_lines
  mv s2, a0  #  lines count
  slli a0, a0, 2
  sbrk
  mv s3, a0  #  array
  mv s4, a0  #  i
  mv a0, s1
  call strchr
  
split_lines_loop:
  beqz a0, end_split_lines_loop
  sb zero, 0(a0)
  sw s1, 0(s4)
  addi s4, s4, 4
  addi a0, a0, 1
  mv s1, a0
  li a1, '\n'
  call strchr
  j split_lines_loop
  
end_split_lines_loop:
  sw s1, 0(s4)
  mv a0, s3
  mv a1, s2
  pop5 ra, s1, s2, s3, s4
  ret


str_to_int:
  push4 ra, s1, s2, s3
  mv s1, a0
  li s2, 0  #  result
  lb a0, 0(s1)
  
str_to_int_loop:
  beqz a0, end_str_to_int_loop
  call symbolcheck
  mv s3, a0
  mv a0, s2
  call mul10
  add s2, a0, s3
  addi s1, s1, 1
  lb a0, 0(s1)
  j str_to_int_loop
  
end_str_to_int_loop:
  mv a0, s2
  pop4 ra, s1, s2, s3
  ret	

	
print_lines:
  push3 ra, s1, s2
  blez a2, error_print_lines
  bge a2, a1, error_print_lines
  mv t0, a2
  addi a2, a2, -1
  slli a2, a2, 2
  add s1, a0, a2
  mv s2, a1
  addi s2, s2, 1
  
print_lines_loop:
  mv a0, t0
  syscall 1
  lw t1, 0(s1)
.data
  str: .asciz ": "
.text
  la a0, str
  syscall 4
  mv a0, t1
  syscall 4
  newline
  addi s1, s1, 4
  addi t0, t0, 1
  bne t0, s2, print_lines_loop
  pop3 ra, s1, s2
  ret
  
error_print_lines:
  error "Start index error"