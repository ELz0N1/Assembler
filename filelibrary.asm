.eqv READ_ONLY 0
.eqv WRITE_ONLY 1
.eqv APPEND_ONLY 9

.macro open
  syscall 1024
.end_macro

.macro read
  syscall 63
.end_macro

.macro lseek
  syscall 62
.end_macro

.macro fclose
  syscall 57
.end_macro

.macro sbrk
  syscall 9
.end_macro


.text
fopen:
  open
  li t0, -1
  beq t0, a0, fopen_error
  ret
fopen_error:
  error "Failed to open file"
    
 
fread:
  read
  li t0, -1
  beq t0, a0, fread_error
  ret
fread_error:
  error "Failed to read file" 
  
 
flength:
  mv t1, a0
  li a1, 0
  li a2, 1
  lseek
  li t0, -1
  beq a0, t0, flenght_error
  
  mv t2, a0
  mv a0, t1
  li a1, 0
  li a2, 2
  lseek
  li t0, -1
  beq a0, t0, flenght_error
  
  mv t3, a0
  mv a0, t1
  mv a1, t2
  li a2, 0
  lseek
  li t0, -1
  beq a0, t0, flenght_error
  
  mv a0, t3
  ret
flenght_error:
  error "Failed to calculate file length"
  
  
fload:
  push3 ra, s1, s2
  mv s1, a0
  
  call flength
  mv s2, a0
  addi a0, a0, 1
  sbrk
  
  li t0, 0
  add t1, a0, s2
  sb t0, 1(t1)
  mv a1, a0
  mv a0, s1
  mv a2, s2
  mv s1, a1
  call fread
  mv a0, s1
  
  pop3 ra, s1, s2
  ret
