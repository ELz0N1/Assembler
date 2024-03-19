div10:
  mv a2, s0
  srli t1, a2, 1
  srli a2, a2, 2
  li t4, 0 # счетчик
divloop:
  li t3, 10
  blt t1, t3, endloop
  sub t1, t1, t3
  addi t4, t4, 1
  j divloop
endloop:
  sub t2, a2, t4
  srli a1, t2, 1
  
  mv a0, a1
  ret
  
mod10:
  push4 ra, s0, s1, s2
  mv s2, s0
  call div10
  mv s0, a0
  li s1, 10
  call multiply
  sub a1, s2, a0
  mv a0, a1
  pop4 ra, s0, s1, s2
  ret
