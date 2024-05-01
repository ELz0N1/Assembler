.include "macrolibrary.asm"
.include "decimallibrary.asm"
.include "divisionlibrary.asm"
.include "multiply.asm"


.text
.global main
main:
  call readDecimal
  mv s0, a0
  call isqrt
  call printDecimal
  
  exit 0
