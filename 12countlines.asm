.include "macrolibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"

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
  mv s2, a0
  
  mv a0, s2
  call count_lines
  syscall 1
  
  mv a0, s1
  fclose
  exit 0  
      
num_of_args_error:
  error "Too few of arguments"
