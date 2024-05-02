.include "macrolibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "strstr.asm"
.include "strstr_testLib.asm"

.text
.global main
main:
  FUNC strstr "strstr"
  OK 0 " " " "
  OK 3 "fffwwqw" "w"
  OK 4 "abc abd" "abd"
  OK 0 "abcde" "a"
  OK 3 "ab abc" "abc"
  NONE "" ""
  NONE "abcde" ""
  NONE "abcdef" "Q"
  NONE " " "qwerty"
  NONE "abc de" "abcd"
  DONE
