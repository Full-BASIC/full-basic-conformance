1 REM FBCS ECMA-0023
2 REM CLAIM A-ECMA-17
3 REM TYPE SELF
100 DIM A$(2), B$(2), M$(2)
110 LET A$(1) = "ab"
120 LET A$(2) = "cd"
130 LET B$(1) = "x"
140 LET B$(2) = "y"
150 MAT M$ = A$ & B$
160 MAT M$ = NUL$
170 MAT M$ = ("Number") & B$
180 IF M$(1) = "Numberx" AND M$(2) = "Numbery" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
