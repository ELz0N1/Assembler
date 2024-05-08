strspan:  #  int strspn(char *str, char *sym)
  push4 ra, s1, s2, s3
  mv s1, a0  #  str
  mv s2, a1  #  sym
  li s3, -1  #  ans
strspan_loop:
  addi s3, s3, 1
  lb a1, 0(s1)
  beqz a1, strspan_end
  mv a0, s2
  li a3, 0
  call strchr
  addi s1, s1, 1
  bnez a0, strspan_loop
strspan_end:
  mv a0, s3
  pop4 ra, s1, s2, s3
  ret