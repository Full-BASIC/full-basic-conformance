1 REM FBCS STR-0042
2 REM CLAIM A-6.5.3-EX
3 REM TYPE SELF
100 REM Examples of 6.5.3: simple LET, array-element target, multiple targets,
110 REM substring target, and a continued (&&) expression. A continuation
120 REM physical line starts with & and carries no line number.
130 LET FAIL = 0
140 LET A$ = "ABC"
150 IF A$ <> "ABC" THEN LET FAIL = FAIL + 1
160 DIM A2$(5)
170 LET A2$(2) = "1234"
180 LET I = 2
190 LET A2$(I) = A2$(2)(3:4)
200 IF A2$(2) <> "34" THEN LET FAIL = FAIL + 1
210 LET A$, B$ = "NEGATIVE DISCRIMINANT"
220 IF A$ <> "NEGATIVE DISCRIMINANT" THEN LET FAIL = FAIL + 1
230 IF B$ <> "NEGATIVE DISCRIMINANT" THEN LET FAIL = FAIL + 1
240 LET C$ = "0123456789"
250 LET C$(7:10) = "wxyz"
260 IF C$ <> "012345wxyz" THEN LET FAIL = FAIL + 1
280 LET D$ = "ABCD" &&
& "XYZ"
290 IF D$ <> "ABCDXYZ" THEN LET FAIL = FAIL + 1
300 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
310 END
