1 REM FBCS STR-0025
2 REM CLAIM A-6.3.4-04
3 REM TYPE SELF
100 REM A string-function-ref substitutes argument values for the parameters of
110 REM the defining algorithm; the scalar result replaces the call.
120 DEF F$(A$) = A$ & A$
130 LET FAIL = 0
140 IF F$("X") <> "XX" THEN LET FAIL = FAIL + 1
150 LET B$ = "ab"
160 IF F$(B$) <> "abab" THEN LET FAIL = FAIL + 1
170 IF "<" & F$(B$) & ">" <> "<abab>" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
