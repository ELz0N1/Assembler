.include "macrolibrary.asm"
.include "bcdlibrary.asm"

.text
.global main
main:
  call readbcd
  mv s0, a0
  
  call readbcd
  mv s1, a0
  
  readch
  mv t1, a0
  newline
  
  li t0,  0x2B #знак плюс
  beq t1, t0, _add
 
  li t0, 0x2D #знак минус
  beq t1, t0, _sub
  
  error "Incorrect operation!"

_add:
  mv a0, t1
  call addition
  j end
  
_sub:
  mv a0, t1
  call subtraction
  j end

end:  
  call printbcd
  exit 0
