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
  li a2, 10
  readch
  beq a0, a2, foo
  addi a1, a0, 0
  li a0, 10
  printch
  addi a0, a1, 0
  printch
  addi a0, a0, 1
  printch
  jal main
foo:
  exit 0
