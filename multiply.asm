multiply: # int multiply(int a4, int a5)
  li t1, 0 # счетчик
  li t3, 0
  mv a4, a0
  mv a5, a1
  
multiplyloop:
  andi t4, a5, 0x00000001
  beqz t4, skip1 
  
  sll t0, a4, t1
  add t3, t3, t0
  
skip1:
  srli a5, a5, 1
  addi t1, t1, 1
  li t2, 31
  blt t1, t2, multiplyloop
  
  mv a0, t3
  ret
