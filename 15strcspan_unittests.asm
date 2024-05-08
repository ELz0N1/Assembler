.include "macrolibrary.asm"
.include "filelibrary.asm"
.include "strchr.asm"
.include "strcspan.asm"
.include "strcspan_testLib.asm"

.text
.global main
main:
  FUNC strcspan "strcspan"
  OK 0 "abcde" "a"
  OK 1 "abcade" "bd"
  OK 3 "abc abcca" " "
  OK 0 "" "ca"
  OK 0 "" ""
  OK 3 "aaa" "b"
  OK 3 "aabsbdfdf" "sdc"
  OK 3 "a a" ""
  OK 0 "0123A" "a"
  OK 3 "aaa" "abc"
  DONE
