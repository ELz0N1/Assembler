.macro write_failed_message %str %chr %res %exp
.data 
  failed_message_1: .asciz "Test is falied: "
  failed_message_2: .asciz ") results in "
  failed_message_3: .asciz "expected "
  comma: .asciz ", "
.text
  la a0, failed_message_1
  syscall 4
  mv a0, s1
  syscall 4
  li a0, '('
  printch
  mv a0, %str
  syscall 4
  la a0, comma
  syscall 4
  mv a0, %chr
  printch
  la a0, failed_message_2
  syscall 4
  write_result %res
  li a0, ' '
  printch
  la a0, failed_message_3
  syscall 4
  write_result %exp
  li a0, '\n'
  printch
.end_macro


.macro write_result %res
.data
  ok: .asciz "OK("
  none: .asciz "NONE"
.text
  li a1 -1
  beq %res, a1, write_res_none

  la a0, ok
  syscall 4
  mv a0, %res
  syscall 1
  li a0, ')'
  printch
  j end_write_res
write_res_none:
  la a0, none
  syscall 4
end_write_res:
.end_macro


.macro FUNC %func %name
.data
  func_name: .asciz %name
  func_message_1: .asciz "Testing function "
  func_message_2: .asciz "...\n"
.text
  la s0, strchr
  la s1, func_name
  la a0, func_message_1
  syscall 4
  la a0, func_name
  syscall 4
  la a0, func_message_2
  syscall 4
.end_macro


.macro OK %ans %str %chr
.data
  string: .asciz %str
.text
  la a0, string
  li a1, %chr
  jalr s0, 0
  la t0, string
  li t3, %ans
  beqz a0, none

  sub t2, a0, t0
  bne t2, t3, failed

  addi s2, s2, 1
  j end
failed:
  addi s3, s3, 1

  li t1 %chr
   write_failed_message t0 t1 t2 t3

   j end
none:
  addi s3, s3, 1

  li t1, %chr
  li t2, -1
  write_failed_message t0 t1 t2 t3
end:
.end_macro


.macro NONE %str %chr
.data
  line: .asciz %str
.text
  la a0, line
  li a1, %chr
  jalr s0, 0

  bnez a0, failed

  addi s2, s2, 1

  j end
failed:
  addi s3, s3, 1

  la t0, line
  li t1, %chr
  sub t2, a0, t0
  li t3, -1
  write_failed_message t0 t1 t2 t3
end:
.end_macro


.macro DONE 
.data
  done_passed: .asciz "Passed: "
  done_failed: .asciz ", failed: "
.text
  la a0, done_passed
  syscall 4
  mv a0, s2
  syscall 1
  la a0, done_failed
  syscall 4
  mv a0, s3
  syscall 1
  exit 0
.end_macro
