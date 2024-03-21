.include "macrolibrary.asm"
.include "decimallibrary.asm"
.include "divisionlibrary.asm"
.include "multiply.asm"

.text
.global main
main:
  call readDecimal
  call printDecimal
  exit 0
