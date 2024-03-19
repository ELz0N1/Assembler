.include "macrolibrary.asm"
.include "hexlibrary.asm"
.include "divisionlibrary.asm"
.include "multiply.asm"

.text
.global main
main:
  call readhex
  mv s0, a0
  
  call div10
  call printhex
  
  newline
  
  call mod10
  call printhex
  
  exit 0
