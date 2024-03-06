.text
.macro syscall %n
  li a7, %n
  ecall
.end_macro

.macro exit %ecode
  li a0, %ecode
  syscall 93
.end_macro

.macro readch # result in a0[0:7]
  syscall 12
.end_macro

.macro printch # argument in a0[0:7]
  syscall 11
.end_macro

.macro printhex # вывод шестнадцатиричного числа
  li a1, 7
  li s3, 10
  mv s4, s2
  li a0, 10
  printch
  li a0, '0'
  printch
  li a0, 'x'
  printch
loop:
  mv t0, a1
  
  mv s4, s2
  slli t0, t0, 2
  srl s4, s4, t0
  
  andi a2, s4, 0x0000000f # маска младший neeble в слове
  blt a2, s3, spot
  addi a2, a2, 7
  
spot:
  addi a0, a2, 48
  printch
  addi a1, a1, -1
  bge a1, x0, loop
.end_macro

main:    #entry point
  li a3, 10
  
scanfirstnumber:
  li a0, 0
  readch
  beq a0, a3, scansecondnumber # Переход к считыванию следующего числа
  
  addi a0, a0, -48
  blt a0, a3, nothex
  andi a0, a0, 0xFFFFFFDF # Преобразование к верхнему регистру
  addi a0, a0, -7 # если число от A - F
  
nothex:
  slli a4, a4, 4
  add a4, a4, a0
  j scanfirstnumber

scansecondnumber:
  li a0, 0
  readch
  beq a0, a3, scanoperation # Переход к считыванию операции
  
  addi a0, a0, -48
  blt a0, a3, nothex2
  andi a0, a0, 0xFFFFFFDF # Преобразование к верхнему регистру
  addi a0, a0, -7 # если число от A - F
  
nothex2:
  slli a5, a5, 4
  add a5, a5, a0
  j scansecondnumber

scanoperation:
  readch
  
  li s1,  0x2B #знак плюс
  beq a0, s1, addition
  li s1, 0x2D #знак минус
  beq a0, s1, subtraction
  li s1, 0x26 # знак &
  beq a0, s1, andoperation
  li s1, 0x7C # знак |
  beq a0, s1, oroperation

  j scanoperation
addition:
  add s2, a4, a5
  printhex
  j end
  
subtraction:
  sub s2, a4, a5
  printhex
  j end
  
andoperation:
  and s2, a4, a5
  printhex
  j end
  
oroperation:
  or s2, a4, a5
  printhex
  j end

end:
  exit 0
  
