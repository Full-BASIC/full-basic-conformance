1 REM FBCS STR-0012
2 REM CLAIM A-6.2.4-05
3 REM TYPE SELF
100 REM If M > N even after clamping, A$(M:N) is the null string before the
110 REM Mth character, or right after the end when M > LEN(A$). Standard
120 REM example: A$ = "1234": A$(3:2) and A$(5:7) are null strings.
130 LET FAIL = 0
140 LET A$ = "1234"
150 IF LEN(A$(3:2)) <> 0 THEN LET FAIL = FAIL + 1
160 IF LEN(A$(5:7)) <> 0 THEN LET FAIL = FAIL + 1
170 IF A$(3:2) <> "" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
