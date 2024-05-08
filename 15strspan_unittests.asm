.include "macrolibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "strspan.asm"
.include "strspan_testLib.asm"

.text
.global main
main:
  FUNC strspan "strspan"
  OK 1 "abcde" "a"
  OK 4 "abcade" "bac"
  OK 0 "abc abcca" " "
  OK 0 "" "ca"
  OK 0 "" ""
  OK 0 "aaa" "b"
  OK 4 "aabsbdfdf" "bac"
  OK 3 "a a" "a"
  OK 4 "0123A" "30"
  OK 3 "aaa" "abc"
  DONE
