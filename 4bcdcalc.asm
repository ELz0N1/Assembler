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

.macro addWithCorrection # коррекция сложения
  li a1, 0 # счетчик
  li s3, 10
  li s7, 7
  li t0, 0
  li s4, 0
  
addloop:
  andi t3, a4, 0x0000000f
  andi t4, a5, 0x0000000f
  add s6, t3, t4
  add s6, s6, s4 # в s4 отслеживаем перенос
  blt s6, s3, skip1
  addi s6, s6, 6
  
skip1:
  srli a4, a4, 4
  srli a5, a5, 4
  srli s4, s6, 4
  andi s5, s6, 0x0000000f
  mv t0, a1
  slli t0, t0, 2
  sll s5, s5, t0
  add s2, s2, s5
  
  addi a1, a1, 1
  blt a1, s7, addloop
.end_macro

.macro subWithCorrection # коррекция вычитания
  li a1, 0 # счетчик
  li s3, 10
  li s7, 7
  li t0, 0
  li s4, 0
  
subloop:
  andi t3, a4, 0x0000000f
  andi t4, a5, 0x0000000f
  sub s6, t3, t4
  sub s6, s6, s4 # в s4 отслеживаем перенос
  li s4, 0
  bge s6, x0, skip2
  addi s6, s6, 10
  li s4, 1
skip2:
  srli a4, a4, 4
  srli a5, a5, 4
  andi s5, s6, 0x0000000f
  mv t0, a1
  slli t0, t0, 2
  sll s5, s5, t0
  add s2, s2, s5
  
  addi a1, a1, 1
  blt a1, s7, subloop
.end_macro

.macro printbcd # вывод шестнадцатиричного числа
  li a1, 7
  li s3, 10
  li s4, 0
  li a0, 10
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
  
  beq a0, a3, scansecondnumber # переход к следующей операции
  
  addi a0, a0, -48
  slli a4, a4, 4
  add a4, a4, a0
  j scanfirstnumber

scansecondnumber:
  li a0, 0
  readch
  
  beq a0, a3, scanoperation # переход к следующей операции
  
  addi a0, a0, -48
  slli a5, a5, 4
  add a5, a5, a0
  j scansecondnumber

scanoperation:
  readch
  
  li s1,  0x2B #знак плюс
  beq a0, s1, addition
  li s1, 0x2D #знак минус
  beq a0, s1, subtraction

  j scanoperation
  
addition:
  addWithCorrection
  printbcd
  j end
  
subtraction:
  subWithCorrection
  printbcd
  j end

end:
  exit 0
