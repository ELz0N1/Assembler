symbolcheck:
  li t0, 103
  bge a0, t0, symbolerror
  li t0, 97
  blt a0, t0, uppercase
  addi a0, a0, -87
  ret
uppercase:
  li t0, 71
  bge a0, t0, symbolerror
  li t0, 65
  blt a0, t0, numbers
  addi a0, a0, -55
  ret
numbers:
  li t0, 58
  bge a0, t0, symbolerror
  li t0, 48
  blt a0, t0, symbolerror
  addi a0, a0, -48
  ret
symbolerror:
  error "Inncorect symbol!"


readhex: # int readhex()
  push3 ra, s0, s1
  li s1, 0 # счетчик цикла
  li s0, 0
  
readloop:
  readch
  
  li t4, 10
  beq a0, t4, quitloop # Выход из цикла
  
  call symbolcheck

  slli s0, s0, 4
  add s0, s0, a0
  addi s1, s1, 1
  j readloop
  
quitloop:
  li t1, 8 # количество допустимых разрядов числа
  slt t2, t1, s1 # записываем код ошибки переполнения числа
  bnez t2, lengtherror
  mv a0, s0
  pop3 ra, s0, s1
  ret  
lengtherror:
  error "Maximum number of characters exceeded!" 
  
  
printhex: # void printhex(n)
  li t0, 7
  li t3, 10
  mv t4, a0
  mv t5, t4

  li a0, '0'
  printch
  li a0, 'x'
  printch
  
loop:
  slli t1, t0, 2
  srl t4, t5, t1

  andi t2, t4, 0x0000000f # маска младший neeble в слове
  blt t2, t3, spot
  addi t2, t2, 7
  
spot:
  addi a0, t2, 48
  printch
  addi t0, t0, -1
  bgez t0, loop
  
  ret
