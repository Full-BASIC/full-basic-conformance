1 REM FBCS STR-0060
2 REM CLAIM D-6.6-2
3 REM TYPE SELF
100 REM Maximum length of a declared string variable with no length-max
110 REM (implementation-defined default, at least 132): here the
120 REM effective limit is 1E9, so MAXLEN returns 1000000000.
130 DECLARE STRING W$
140 LET FAIL = 0
150 IF MAXLEN(W$) <> 1000000000 THEN LET FAIL = FAIL + 1
160 IF MAXLEN(W$) < 132 THEN LET FAIL = FAIL + 1
170 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
180 END
