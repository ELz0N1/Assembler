div10:
  push3 ra, s0, s1
  mv s1, a0
  li s0, 0
  li t0, 10
  blt a0, t0, enddiv10
  mv s0, a0
  srli a0, a0, 1
  call div10
  srli s0, s0, 2
  sub s0, s0, a0
  srli s0, s0, 1
enddiv10:
  mv a0, s0
  li a1, 10
  call multiply
  slt a0, s1, a0
  sub a0, s0, a0
  pop3 ra, s0, s1
  ret
 
mod10:
  push2 ra, s0
  mv s0, a0
  call div10
  li a1, 10
  call multiply
  sub a0, s0, a0
  pop2 ra, s0
  ret
