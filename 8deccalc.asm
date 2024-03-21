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
  mv s1, a0
  
  call readOperation
  
  mv t0, a0
  newline
  mv a0, t0
  
  call printDecimal
  exit 0
