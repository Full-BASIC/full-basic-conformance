1 REM FBCS STR-0014
2 REM CLAIM D-6.2-2
3 REM TYPE SELF
100 REM Default max length of an undeclared string variable (impl-defined,
110 REM at least 132): the effective limit is 1E9, so MAXLEN returns 1000000000.
120 LET FAIL = 0
130 IF MAXLEN(A$) <> 1000000000 THEN LET FAIL = FAIL + 1
140 IF MAXLEN(A$) < 132 THEN LET FAIL = FAIL + 1
150 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
160 END
