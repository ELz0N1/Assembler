.include "macrolibrary.asm"
.include "decimallibrary.asm"
.include "divisionlibrary.asm"
.include "multiply.asm"


.text
.global main
main:
  call readDecimal
  mv s0, a0
  
  call readDecimal
  mv a1, a0
  mv a0, s0
  
  call sdiv
  call printDecimal
  
  exit 0
