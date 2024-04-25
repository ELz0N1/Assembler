.include "macrolibrary.asm"
.include "divisionlibrary.asm"
.include "multiply.asm"
.include "decimallibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "split&print_lines.asm"


.text
.global main
main:
  mv s10, a0
  mv s11, a1

  li t0, 1
  bne t0, s10, num_of_args_error
  lw s1, 0(s11)
  
  li a1, READ_ONLY
  mv a0, s1
  call fopen
  mv s1, a0
  
  call fload
  call split_lines
  
  li a2, 1
  li t0, 1
  beq s10, t0, end
  mv s2, a0
  mv s3, a1
  lw a0, 4(s11)
  call str_to_int
  mv a2, a0
  mv a0, s2
  mv a1, s3

  sub a2, a1, a2
  addi a2, a2, 1

end:	
  call print_lines
  mv a0, s1
  fclose
  exit 0  
      
num_of_args_error:
  error "Too few of arguments"
