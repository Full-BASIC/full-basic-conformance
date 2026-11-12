1 REM FBCS STR-0022
2 REM CLAIM A-6.3.4-01
3 REM TYPE SELF
100 REM Value of a string-expression is the concatenation of its primaries
110 REM in order. Standard example (l.2536): A$="COME ", B$="IN".
120 LET FAIL = 0
130 LET A$ = "COME "
140 LET B$ = "IN"
150 IF A$ & B$ <> "COME IN" THEN LET FAIL = FAIL + 1
160 IF B$ & A$ <> "INCOME " THEN LET FAIL = FAIL + 1
170 IF "a" & "b" & "c" <> "abc" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
