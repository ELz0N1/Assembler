.include "library.asm"

.text
main:    #entry point
  li t0, 10
  readch
  beq a0, t0, end
  addi a1, a0, 0
  li a0, 10
  printch
  addi a0, a1, 0
  printch
  addi a0, a0, 1
  printch
  j main
  
end:
  exit 0
