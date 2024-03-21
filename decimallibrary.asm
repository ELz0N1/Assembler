.macro addWithOverflowCheck %r1 %r2 %r3
  add %r1, %r2, %r3
  sltz t0, %r3
  slt t1, %r1, %r2
  beq t0, t1, skiperror
  error "Overflow error"
skiperror:
.end_macro


symbolcheck:
  li t0, 58
  bge a0, t0, symbolerror
  li t0, 48
  blt a0, t0, symbolerror
  addi a0, a0, -48
  ret
  
symbolerror:
  error "Inncorect symbol!"


readDecimal:
  push3 ra, s0, s1
  li s0, 0
  li s1, 0
	
  readch	
  li t0, 10
  beq a0, t0, endloop
  li t0, '-'
  bne a0, t0, plus
  addi s1, s1, 1
  j readloop
  
plus:
  call symbolcheck
  add s0, s0, a0
  
readloop:
  readch
  li t0, 10
  beq a0, t0, endloop
  call symbolcheck
  swap s0, a0
  
  li t0, 214748364
  bge a0, t0, err_muloverflow
  slli t0, a0, 3
  add t0, t0, a0
  add a0, t0, a0
  
  addWithOverflowCheck s0, s0, a0
  j readloop
  
endloop:
  beqz s1, endread
  neg s0, s0
  
endread:
  mv a0, s0
  pop3 ra, s0, s1
  ret
  
err_muloverflow:
  error "Overflow error!"
  
  
printDecimal:
  push3 ra, s0, s1
  li s1, 0
  mv s0, a0
  bgez a0, digitcount
  li a0, '-'
  printch
  neg s0, s0
  mv a0, s0
  
digitcount:
  call mod10
  push a0
  mv a0, s0
  call div10
  mv s0, a0
  addi s1, s1, 1
  bnez a0, digitcount
  
loopprintdecimal:
  pop a0
  addi a0, a0, 48
  printch
  addi s1, s1, -1
  bnez s1, loopprintdecimal
  pop3 ra, s0, s1
  ret


readOperation:
  readch
  
  li t0,  '+'
  beq a0, t0, _add
 
  li t0, '-'
  beq a0, t0, _sub
  
  error "Incorrect operation!"

_sub:
  neg s1, s1

_add:
  addWithOverflowCheck a0, s0, s1
  ret