.include "macrolibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "strchr_testLib.asm"

.text
.global main
main:
  FUNC strchr "strchr"
  OK 0 "abcde" 'a'
  OK 3 "fffwwqw" 'w'
  OK 2 "abcde" 'a'
  OK 3 "abc" '\0'
  NONE "abcdef" 'Q'
  NONE "" '?'
  NONE "abcde" 'e'
  DONE
