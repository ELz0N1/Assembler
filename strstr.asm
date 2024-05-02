strstr: # a0 - ptr to the main string, a1 - ptr to the substring
  push3 ra, s1, s2
  mv s1, a1
  
strstr_loop:
  lb a1, 0(a1)
  call strchr
  mv s2, a0
  beqz a0, strstr_not_found
  mv a1, s1
  
strstr_match_loop:
  lb t2, 0(a0)
  lb t3, 0(a1)
  
  beqz t3, strstr_found    
  beqz t2, strstr_not_found
  beq t2, t3, strstr_match
  
  mv a1, s1
  mv a0, s2
  addi a0, a0, 1
  j strstr_loop

strstr_match:
  addi a0, a0, 1
  addi a1, a1, 1
  j strstr_match_loop

strstr_found:
  mv a0, s2
  j strstr_end

strstr_not_found:
  li a0, 0

strstr_end:
  pop3 ra, s1, s2
  ret