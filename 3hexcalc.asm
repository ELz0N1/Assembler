.include "library.asm"

.text
main:    #entry point 

  call readhex
  beqz s7, skiperror1
  error "Maximum number of characters exceeded!"
  
skiperror1:
  mv a4, a5
  li a5, 0
  
  call readhex
  beqz s7, skiperror2
  error "Maximum number of characters exceeded!"

skiperror2:
  readch 
  
  li t2,  0x2B #знак плюс
  beq a0, t2, addition
  li t2, 0x2D #знак минус
  beq a0, t2, subtraction
  li t2, 0x26 # знак &
  beq a0, t2, andoperation
  li t2, 0x7C # знак |
  beq a0, t2, oroperation
  
addition:
  add s2, a4, a5
  call printhex
  j end
  
subtraction:
  sub s2, a4, a5
  call printhex
  j end
  
andoperation:
  and s2, a4, a5
  call printhex
  j end
  
oroperation:
  or s2, a4, a5
  call printhex
  j end

end:
  exit 0

readhex:
  li t3, 10
  li t2, 0 # счетчик цикла
  li t1, 8
  li s7, 0 # код ошибки
  li a0, 0
  
readloop:
  readch
  beq a0, t3, quitloop # Выход из цикла
  
  addi a0, a0, -48
  blt a0, t3, nothex
  andi a0, a0, 0xFFFFFFDF # Преобразование к верхнему регистру
  addi a0, a0, -7 # если число от A - F
  
nothex:
  slli a5, a5, 4
  add a5, a5, a0
  addi t2, t2, 1
  j readloop
  
  quitloop:
  slt s7, t1, t2 # записываем код ошибки переполнения числа
  ret
  
printhex: # вывод шестнадцатиричного числа
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
  mv t4, s2
  
  slli t1, t1, 2
  srl t4, t4, t1
  
  andi a2, t4, 0x0000000f # маска младший neeble в слове
  blt a2, t3, spot
  addi a2, a2, 7
  
spot:
  addi a0, a2, 48
  printch
  addi t0, t0, -1
  bgez t0, loop

  ret
