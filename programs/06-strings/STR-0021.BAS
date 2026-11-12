1 REM FBCS STR-0021
2 REM CLAIM A-6.3.3-EX
3 REM TYPE SELF
100 REM Examples of 6.3.3: concatenation with variables, substring-qualified
110 REM element and constant; array element with substring qualifier.
120 LET FAIL = 0
130 LET A2$ = "two"
140 LET B$ = "bbbbbbbbbbbbbbbbbbbbbbbbb"
150 IF A2$ & B$(4:22) & "223" <> "twobbbbbbbbbbbbbbbbbbb223" THEN LET FAIL = FAIL + 1
160 DIM X$(2,3)
170 LET X$(1,3) = "element"
180 LET I = 1
190 LET J = 4
200 IF X$(1,3)(I:J) <> "elem" THEN LET FAIL = FAIL + 1
210 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
220 END
