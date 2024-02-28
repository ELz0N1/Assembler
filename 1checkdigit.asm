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

main:    #entry point
  readch
  andi s0, a0, 0xff
  addi a0, a0, -48
  sltiu a0, a0, 10
  addi a1, a0, 48
  li a0, 10
  printch
  addi a0, a1, 0
  printch 
  exit 0
