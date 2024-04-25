strchr: # a0 = string, a1 = char to find 
strchr_loop:
  lb t1, 0(a0)
  beqz t1, chr_not_found
  beq t1, a1, end_strchr
  addi a0, a0, 1
  j strchr_loop
chr_not_found:
  li a0, 0
end_strchr:
  ret


count_lines:
  push3 ra, s1, s2
  li s1, 0
  mv s2, a0
count_lines_loop:
  li a1, '\n'
  call strchr
  beqz a0, end_count_lines_loop
  addi s1, s1, 1
  addi a0, a0, 1
  mv s2, a0
  j count_lines_loop
end_count_lines_loop:
  mv a0, s2
  li t2, ' '
not_empty_loop:
  lb t1, 0(a0)
  beqz t1, end_count_lines
  blt t2, t1, end_not_empty
  addi a0, a0, 1
  j not_empty_loop
end_not_empty:
  addi s1, s1, 1
end_count_lines:
  mv a0, s1
  pop3 ra, s1, s2
  ret
  