symbolcheck:
  li t0, 58
  bge a0, t0, symbolerror
  li t0, 48
  blt a0, t0, symbolerror
  addi a0, a0, -48
  ret
symbolerror:
  error "Inncorect symbol!"

readbcd:
  push3 ra, s0, s1
  li s0, 0xA # знак плюс в число
  li t2, 0 # счетчик цикла
  
readloop:
  readch
  li t0, 10
  beq a0, t0, quitloop # Выход из цикла
  
  li t4, 0x2D # знак минус
  bne a0, t4, plus
  li s0, 0xB # знак минус в число
  j readloop
  
 plus:
  call symbolcheck
  slli s1, s1, 4
  add s1, s1, a0
  addi t2, t2, 1
  j readloop
  
quitloop:
  li t3, 7
  slt t3, t3, t2
  bnez t3, lengtherror
  slli s1, s1, 4
  add s1, s1, s0 
  mv a0, s1
  pop3 ra, s0, s1
  ret
lengtherror:
  error "Maximum number of characters exceeded!" 


addWithCorrection: # сложение с коррекцией
  push s4
  li t0, 0
  li t1, 0 # счетчик
  li t2, 6
  mv a4, s0
  mv a5, s1
  
addloop:
  andi t3, a4, 0x0000000f
  andi t4, a5, 0x0000000f
  add t5, t3, t4
  add t5, t5, s4 # в s4 отслеживаем перенос
  li a3, 10 
  blt t5, a3, skip1
  addi t5, t5, 6
  
skip1:
  srli a4, a4, 4
  srli a5, a5, 4
  srli s4, t5, 4
  andi t6, t5, 0x0000000f
  slli t0, t1, 2
  sll t6, t6, t0
  add a1, a1, t6
  
  addi t1, t1, 1
  blt t1, t2, addloop
  
  slli a1, a1, 4
  add a1, a1, s2
  mv a0, a1
  
  pop s4
  ret


subWithCorrection: # вычитание с коррекцией
  push s4
  li t0, 0
  li t1, 0 # счетчик
  li t2, 6
  mv a4, s0
  mv a5, s1

subloop:
  andi t3, a4, 0x0000000f
  andi t4, a5, 0x0000000f
  sub t5, t3, t4
  sub t5, t5, s4 # в s4 отслеживаем перенос
  li s4, 0
  bgez t5, skip2
  addi t5, t5, 10
  li s4, 1
  
skip2:
  srli a4, a4, 4
  srli a5, a5, 4
  andi t6, t5, 0x0000000f
  slli t0, t1, 2
  sll t6, t6, t0
  add a1, a1, t6
  
  addi t1, t1, 1
  blt t1, t2, subloop
  
  slli a1, a1, 4
  add a1, a1, s2
  mv a0, a1
  pop s4
  ret
  
addition:
  push4 ra, s0, s1, s2
  andi t1, s0, 0x0000000f # знак 1ого числа
  srli s0, s0, 4
  andi t2, s1, 0x0000000f # знак 2ого числа
  srli s1, s1, 4
  
  bne t1, t2, addfirstminus
  
  mv s2, t1  # одинаковые знаки
  call addWithCorrection
  j endadd
   
addfirstminus: # первое число отрицательное, второе положительное
  blt t1, t2, addsecondminus
  
  blt s1, s0, firstbiggeradd1
  # второе число по модулю больше первого
  mv s2, t2
  swap s0, s1
  call subWithCorrection
  j endadd
  
firstbiggeradd1:
# первое число по модулю больше второго
  mv s2, t1

  call subWithCorrection
  j endadd
  
addsecondminus: # второе число отрицательное, первое положительное
  blt s1, s0, firstbiggeradd2
  # второе число по модулю больше первого
  mv s2, t2
  swap s0, s1
  call subWithCorrection
  j endadd
  
firstbiggeradd2:
# первое число по модулю больше второго
  mv s2, t1
  call subWithCorrection
  j endadd

endadd:
  pop4 ra, s0, s1, s2
  ret
  
subtraction:
  push4 ra, s0, s1, s2
  andi t1, s0, 0x0000000f # знак 1ого числа
  srli s0, s0, 4
  andi t2, s1, 0x0000000f # знак 2ого числа
  srli s1, s1, 4
  
  bne t1, t2, subfirstminus
  
  mv s2, t1 # одинаковые знаки
  call subWithCorrection
  j endsub
   
subfirstminus: # первое число отрицательное, второе положительное
  blt t1, t2, subsecondminus
  
  blt s1, s0, firstbiggersub1
  # второе число по модулю больше первого
  mv s2, t1
  call addWithCorrection
  j endsub
  
firstbiggersub1:
# первое число по модулю больше второго
  mv s2, t1
  call addWithCorrection
  j endsub
  
subsecondminus:# второе число отрицательное, первое положительное
  blt s1, s0, firstbiggersub2
  # второе число по модулю больше первого
  mv s2, t1
  swap s0, s1
  call addWithCorrection
  j endsub
  
firstbiggersub2:
# первое число по модулю больше второго
  mv a0, t1
  call addWithCorrection
  j endsub

endsub:
  pop4 ra, s0, s1, s2
  ret

printbcd: # void printbcd(n)
  li t0, 6
  li t3, 0
  mv t4, a0
  
  andi a0, t4, 0x0000000f # знак числа
  beqi a0, 0xA, plusint
  li a0, '-'
  printch
plusint:
  srli t4, t4, 4
  
  mv t5, t4
  
loop:
  slli t1, t0, 2
  srl t4, t5, t1
  andi t2, t4, 0x0000000f # маска младший neeble в слове
  addi a0, t2, 48
  printch 
  addi t0, t0, -1
  bgez t0, loop
 
  ret
