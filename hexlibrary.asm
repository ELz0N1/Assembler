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


readhex:
  li t4, 10
  li t1, 8 # количество допустимых разрядов числа
  li t2, 0 # счетчик цикла
  push3 ra, s0, s1
  li s0, 0
  li s1, 0
  
readloop:
  readch
  beq a0, t4, quitloop # Выход из цикла
  slt s1, t1, t2 # записываем код ошибки переполнения числа
  bnez s1, lengtherror
  call symbolcheck

  slli s0, s0, 4
  add s0, s0, a0
  addi t2, t2, 1
  j readloop
  
quitloop:
  mv a0, s0
  pop3 ra, s0, s1
  ret 
lengtherror:
  error "Maximum number of characters exceeded!" 
  
  
printhex: # вывод шестнадцатиричного числа
  push3 ra, s1, s2
  li s1, 0
  li s2, 0
  mv s1, a0
  mv s2, s1
  li t0, 7
  li t3, 10
  li a0, 10
  printch
  li a0, '0'
  printch
  li a0, 'x'
  printch
  
loop:
  mv t1, t0
  mv s1, s2
  slli t1, t1, 2
  srl s1, s1, t1
  
  andi t2, s1, 0x0000000f # маска младший neeble в слове
  blt t2, t3, spot
  addi t2, t2, 7
  
spot:
  addi a0, t2, 48
  printch
  addi t0, t0, -1
  bgez t0, loop
  
  pop3 ra, s1, s2
  ret
