1 REM FBCS STR-0054
2 REM CLAIM A-6.6.4-03
3 REM TYPE SELF
100 REM The implementation-defined default maximum string length shall be at
110 REM least 132. Here the effective limit is 1E9: MAXLEN returns 1000000000.
120 LET FAIL = 0
130 IF MAXLEN(A$) < 132 THEN LET FAIL = FAIL + 1
140 IF MAXLEN(A$) <> 1000000000 THEN LET FAIL = FAIL + 1
150 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
160 END
