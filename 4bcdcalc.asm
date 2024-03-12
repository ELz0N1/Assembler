.include "library.asm"

.text
main:    #entry point
  li a3, 10
  
  call readbcd
  beqz s7, skiperror
  error "Maximum number of characters exceeded!"
skiperror:
  mv a4, a5
  li a5, 0
  call readbcd
  beqz s7, skiperror2
  error "Maximum number of characters exceeded!"
skiperror2:
  
  andi s8, a4, 0x0000000f # знак 1ого числа
  srli a4, a4, 4
  andi s9, a5, 0x0000000f # знак 2ого числа
  srli a5, a5, 4
  
 readch
  li s1,  0x2B #знак плюс
  beq a0, s1, addition
 
  
  li s1, 0x2D #знак минус
  beq a0, s1, subtraction
  
  
addition:
  bne s8, s9, addfirstminus
  
  mv s10, s8  # одинаковые знаки
  call addWithCorrection
  j endadd
   
addfirstminus: # первое число отрицательное, второе положительное
  blt s8, s9, addsecondminus
  
  blt a5, a4, firstbiggeradd1
  mv s10, s9  # второе число по модулю больше первого
  swap a4, a5
  call subWithCorrection
  j endadd
  
firstbiggeradd1: # первое число по модулю больше второго
  mv s10, s8

  call subWithCorrection
  j endadd
  
addsecondminus: # второе число отрицательное, первое положительное
  blt a5, a4, firstbiggeradd2
  
  mv s10, s9  # второе число по модулю больше первого
  swap a4, a5
  call subWithCorrection
  j endadd
  
firstbiggeradd2: # первое число по модулю больше второго
  mv s10, s8
  call subWithCorrection
  j endadd

endadd:
  call printbcd
  j end
  
subtraction:
  bne s8, s9, subfirstminus
  
  mv s10, s8 # одинаковые знаки
  call subWithCorrection
  j endsub
   
subfirstminus: # первое число отрицательное, второе положительное
  blt s8, s9, subsecondminus
  
  blt a5, a4, firstbiggersub1  # второе число по модулю больше первого
  mv s10, s8
  call addWithCorrection
  j endsub
  
firstbiggersub1: # первое число по модулю больше второго
  mv s10, s8
  call addWithCorrection
  j endsub
  
subsecondminus: # второе число отрицательное, первое положительное
  blt a5, a4, firstbiggersub2 # второе число по модулю больше первого
  
  mv s10, s8
  swap a4, a5
  call addWithCorrection
  j endsub
  
firstbiggersub2: # первое число по модулю больше второго
  mv s10, s8
  call addWithCorrection
  j endsub

endsub:
  call printbcd
  j end
  
end:
  exit 0


readbcd:
  li a0, 0
  li a3, 10
  li t1, 0xA
  li t0, 0x2D # знак минус
  li t2, 0 # счетчик цикла
  li t3, 7
  li s7, 0 # код ошибки
  
readloop:
  readch
  beq a0, a3, quitloop # Выход из цикла
  bne a0, t0, plus
  li t1, 0xB
  j readloop
  
 plus:
  addi a0, a0, -48
  slli a5, a5, 4
  add a5, a5, a0
  addi t2, t2, 1
  j readloop
  
  quitloop:
  slli a5, a5, 4
  add a5, a5, t1 
  slt s7, t3, t2
  ret


addWithCorrection: # сложение с коррекцией
  li a1, 0 # счетчик
  li s3, 10
  li t2, 6
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
  blt a1, t2, addloop
  
  slli s2, s2, 4
  add s2, s2, s10
  
  ret

subWithCorrection: # коррекция вычитания
  li a1, 0 # счетчик
  li s3, 10
  li s7, 6
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
  
  slli s2, s2, 4
  add s2, s2, s10
  
  ret
  
printbcd: # вывод шестнадцатиричного числа
  li t0, 7
  li s3, 10
  li s4, 0
  li a0, 10
  printch
  
loop:
  mv t1, t0
  mv s4, s2
  slli t1, t1, 2
  srl s4, s4, t1
  
  andi a2, s4, 0x0000000f # маска младший neeble в слове
  blt a2, s3, spot
  addi a2, a2, 7
  
spot:
  addi a0, a2, 48
  printch
  addi t0, t0, -1
  bgez t0, loop
  
  ret
