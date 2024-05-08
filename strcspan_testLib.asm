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
  ok_test_failed: .asciz "Test falied: "
  ok_func_name: .asciz "strstr"
  ok_open_bracket: .asciz "(“"
  ok_res: .asciz "”) results in OK("
  ok_exp_ok: .asciz "), expected OK("
  ok_exp_none: .asciz "), expected NONE\n"
  ok_comma:  .asciz "”, ”"
  ok_end_string: .asciz ")\n"
.text
	la a0, str1
	la a1, str2
	mv s1, a0
	mv s2, a1
	li s3, %ans
	call strcspan
	mv s4, a0
	bne s3, s4, OK_test_falied
	addi s5, s5, 1
	j OK_end
	
OK_test_falied:
  la a0, ok_test_failed
  syscall 4 

  la a0, ok_func_name
  syscall 4

  la a0, ok_open_bracket
  syscall 4 
  
  mv a0, s1
  syscall 4

  la a0, ok_comma
  syscall 4 
  
  mv a0, s2
  syscall 4

  la a0, ok_res
  syscall 4 
  
  mv a0, s3
  syscall 1

  la a0, ok_exp_ok
  syscall 4 
  
  mv a0, s4
  syscall 1

  la a0, ok_end_string
  syscall 4
  addi s6, s6, 1
OK_end:
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