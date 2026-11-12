1 REM FBCS STR-0005
2 REM CLAIM A-6.1.4-03
3 REM TYPE SELF
100 REM Spaces (incl. trailing) are significant; "" is the null string;
110 REM upper- and lower-case letters are distinct.
120 LET FAIL = 0
130 IF LEN("A ") <> 2 THEN LET FAIL = FAIL + 1
140 IF "A " = "A" THEN LET FAIL = FAIL + 1
150 IF LEN("") <> 0 THEN LET FAIL = FAIL + 1
160 IF "A" = "a" THEN LET FAIL = FAIL + 1
170 IF "ABC" = "abc" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
