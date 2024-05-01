.macro add_with_overflow_check %r1 %r2 %r3
  add %r1, %r2, %r3
  sltz t0, %r3
  slt t1, %r1, %r2
  beq t0, t1, skip_error
  error "Overflow error"
skip_error:
.end_macro



symbolcheck:
  li t0, 58
  bge a0, t0, symbol_error
  li t0, 48
  blt a0, t0, symbol_error
  addi a0, a0, -48
  ret
  
symbol_error:
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
  
  call mul10 # добавил
  
  add_with_overflow_check s0, s0, a0
  j readloop
  
endloop:
  beqz s1, endread
  neg s0, s0
  
endread:
  mv a0, s0
  pop3 ra, s0, s1
  ret
  
err_muloverflow:
  error "Overflow error"
  
 
   
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
  add_with_overflow_check a0, s0, s1
  ret
  
  
  
lenbinform:
  li t0, 0

lenbinloop:
  srli a0, a0, 1
  addi t0, t0, 1
  bnez a0, lenbinloop
  
  mv a0, t0
  ret


	
udiv:
  push3 ra, s0, s1
  beqz a1, udiv_error
  mv s0, a0 # dividend
  mv s1, a1 # divisor
  
  call lenbinform # a1 = len(divisor)
  swap a0, a1
  call lenbinform # a0 = len(dividend)
  
  li t1, 0xffffffff
  sub t0, a1, a0  # t0 = len(dividend) - len(divisor)
  sll t1, t1, t0 
  sll s1, s1, t0
  li t3, 0 # quotient
  
udiv_loop:
  and t2, s0, t1 # t2 = current dividend
  slli t3, t3, 1
  blt t2, s1, udiv_loop_end
  addi t3, t3, 1
  sub s0, s0, s1
  
udiv_loop_end:
  srli t1, t1, 1
  srli s1, s1, 1
  addi t0, t0, -1
  bgez t0, udiv_loop
	
  mv a0, t3
  pop3 ra, s0, s1
  ret
  
udiv_error:
  error "Сan't be divided by zero"



sdiv:
  push2 ra, s0
  li s0, 0
  bgez a0, sdivsecondnumber
  neg a0, a0
  addi s0, s0, 1
  
sdivsecondnumber:
  bgez a1, sdivexecution
  neg a1, a1
  addi s0, s0, -1
  
sdivexecution:
  call udiv
  beqz s0, sdiv_end
  neg a0, a0
  
sdiv_end:
  pop2 ra, s0
  ret



isqrt:
  push ra
  bltz a0, isqrt_error
  li t0, 30
  li t1, 0 # result
  
isqrt_loop:
  li t2, -1
  sll t2, t2, t0
  and t3, a0, t2 # t3 = tmp sqrt(a0)
  slli t1, t1, 1
  slli t4, t1, 1
  addi t4, t4, 1
  sll t4, t4, t0
  
  blt t3, t4, isqrt_loop_end
  addi t1, t1, 1
  sub a0, a0, t4
  
isqrt_loop_end:
  addi t0, t0, -2
  bgez t0, isqrt_loop
  mv a0, t1
  pop ra
  ret
  
isqrt_error:
  error "isqrt can't take negative input values"