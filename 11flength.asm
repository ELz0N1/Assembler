.include "macrolibrary.asm"
.include "filelibrary.asm"

.data
  name: .asciz "Input file name: "
  len: .asciz "File length: "

.text
.global main
main:
  mv s10, a0
  mv s11, a1

  li t0, 1
  bne t0, s10, num_of_args_error
  lw s1, 0(s11)
  
  la a0, name
  syscall 4
    
  li a1, READ_ONLY
  mv a0, s1
  syscall 4
  call fopen
  mv s1, a0
  
  call flength
  
  mv s2, a0
  swap s1, a0
    
  newline
  la a0, len
  syscall 4
    
  mv a0, s1
  syscall 1
    
  mv a0, s2
  call fload
    
  swap s2, a0
  fclose
  exit 0  
      
num_of_args_error:
  error "Too few of arguments"
