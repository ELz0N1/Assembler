.macro FUNC %func %name
.data
  func_name: .asciz %name
  func_message_1: .asciz "Testing function "
  func_message_2: .asciz "...\n"
.text
  la a0, func_message_1
  syscall 4
  la a0, func_name
  syscall 4
  la a0, func_message_2
  syscall 4
.end_macro



.macro OK %ans %str1 %str2
.data
  str1: .asciz %str1
  str2: .asciz %str2
  OK_test_failed: .asciz "Test falied: "
  OK_func_name: .asciz "strstr"
  OK_open_bracket: .asciz "(“"
  OK_res: .asciz "”) results in OK("
  OK_exp_ok: .asciz "), expected OK("
  OK_exp_none: .asciz "), expected NONE\n"
  OK_comma:  .asciz "”, ”"
  OK_end_string: .asciz ")\n"
.text
  la a0, str1
  la a1, str2
  mv s1, a0
  mv s2, a1
  li s3, %ans
  call strstr
  mv s4, a0
  beqz a0, OKtestfaliednone
  sub s4, s4, s1
  bne s3, s4, OKtestfalied
  addi s5, s5, 1
  j endOKtest
OKtestfalied:

  la a0, OK_test_failed
  syscall 4 

  la a0, OK_func_name
  syscall 4

  la a0, OK_open_bracket
  syscall 4 
  
  mv a0, s1
  syscall 4

  la a0, OK_comma
  syscall 4 
  
  mv a0, s2
  syscall 4

  la a0, OK_res
  syscall 4 
  
  mv a0, s3
  syscall 1

  la a0, OK_exp_ok
  syscall 4 
  
  mv a0, s4
  syscall 1

  la a0, OK_end_string
  syscall 4 

  addi s6, s6, 1
  j endOKtest
OKtestfaliednone:
  la a0, OK_test_failed
  syscall 4 
  
  la a0, OK_func_name
  syscall 4

  la a0, OK_open_bracket
  syscall 4
  
  mv a0, s1
  syscall 4

  la a0, OK_comma
  syscall 4
  
  mv a0, s2
  syscall 4

  la a0, OK_res
  syscall 4
  
  mv a0, s3
  syscall 1

  la a0, OK_exp_none
  syscall 4
  addi s6, s6, 1
endOKtest:
.end_macro


.macro NONE %str1 %str2
.data
  str1: .asciz %str1
  str2: .asciz %str2
  NONE_test_failed: .asciz "Test falied: "
  NONE_func_name: .asciz "strstr"
  NONE_open_bracket: .asciz "(“"
  NONE_res: .asciz "”) results in OK("
  NONE_res_exp: .asciz "”) results in NONE, expected OK("
  NONE_comma:  .asciz "”, ”"
  NONE_end_string: .asciz ")\n"
.text
  la a0, str1
  la a1, str2
  mv s1, a0
  mv s2, a1
  call strstr
  mv s4, a0
  bnez s4, NONEtestfalied
  addi s5, s5, 1
  j NONE_test_end
NONEtestfalied:
  la a0, NONE_test_failed
  syscall 4

  la a0, NONE_func_name
  syscall 4

  la a0, NONE_open_bracket
  syscall 4
  
  mv a0, s1
  syscall 4

  la a0, NONE_comma
  syscall 4 
  
  mv a0, s2
  syscall 4

  la a0, NONE_res_exp
  syscall 4 

  #sub s4, s4, s1
  mv a0, s4
  syscall 1

  la a0, NONE_end_string
  syscall 4
  addi s6, s6, 1
NONE_test_end:
.end_macro



.macro DONE 
.data
  done_passed: .asciz "Passed: "
  done_failed: .asciz ", failed: "
.text
  la a0, done_passed
  syscall 4
  mv a0, s5
  syscall 1
  la a0, done_failed
  syscall 4
  mv a0, s6
  syscall 1
  exit 0
.end_macro
