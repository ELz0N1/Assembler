.include "macrolibrary.asm"
.include "hexlibrary.asm"

.text
.global main
main:    #entry point 

  call readhex
  mv s0, a0
  
  call readhex
  mv s1, a0
  
  readch # считываем знак операции
  
  li t2,  0x2B #знак плюс
  beq a0, t2, addition
  li t2, 0x2D #знак минус
  beq a0, t2, subtraction
  li t2, 0x26 # знак &
  beq a0, t2, andoperation
  li t2, 0x7C # знак |
  beq a0, t2, oroperation
  error "Incorrect operation!"
  
addition:
  newline
  add a0, s0, s1
  call printhex
  j end
  
subtraction:
  newline
  sub a0, s0, s1
  call printhex
  j end
  
andoperation:
  newline
  and a0, s0, s1
  call printhex
  j end
  
oroperation:
  newline
  or a0, s0, s1
  call printhex
  j end

end:
  exit 0
  
