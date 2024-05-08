.include "macrolibrary.asm"
.include "divisionlibrary.asm"
.include "decimallibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "split&print_lines.asm"
.include "strspan.asm"
.include "strcspan.asm"
.include "wc.asm"


.macro check_arg %arg, %f, %label
  li t0, %arg
  bne t2, t0, %label
  addi s4, s4, %f
  j parsing_end
.end_macro


.text
.global main
main:
  mv s10, a0
  mv s11, a1
  li s4, 0 # flags
  li t3, 0 # count
  li t0, 2
  blt s10, t0, arguments_error
	
parsing:
  lw t1, 0(s11) 
  lb t2, 0(t1)
  li t0, '-'
  bne t2, t0, wc_test
  lb t2, 1(t1)
  
  check_arg 'l', 8, check_w
check_w:
  check_arg 'w', 4, check_c
check_c:
  check_arg 'c', 2, check_L
check_L:
  check_arg 'L', 1, parsing_error
  
parsing_end:
  lb t2, 2(t1)
  bnez t2, parsing_error
  addi t3, t3, 1
  addi s11, s11, 4
  j parsing
  
parsing_error:
  error "Unknown flag"
	
wc_test:
  lw s1, 0(s11)
  mv a0, s1
  li a1, READ_ONLY
  call fopen
  mv s1, a0
  mv a1, s1
  call fload
  mv a1, s2
  mv a2, s4
  call wc
  mv a0, s1
  fclose
  exit 0
  
arguments_error:
  error "Too few arguments!"
