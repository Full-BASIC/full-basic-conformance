1 REM FBCS STR-0004
2 REM CLAIM A-6.1.4-02
3 REM TYPE SELF
100 REM Two adjacent quotation marks inside a constant are one quote character.
110 LET FAIL = 0
120 IF LEN("""") <> 1 THEN LET FAIL = FAIL + 1
130 LET Q$ = """"
140 LET A$ = Q$
150 IF A$ <> Q$ THEN LET FAIL = FAIL + 1
160 IF LEN("He said, ""Don't"".") <> 17 THEN LET FAIL = FAIL + 1
170 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
180 END
