1 REM FBCS NUM-0276
2 REM CLAIM A-5.6.2-TR173
3 REM TYPE OUTPUT
4 REM STD 5.6.2 l.2216-2218: string functions and UBOUND are not numeric-supplied-functions; OPTION ANGLE after them is accepted.
10 DIM A(2)
20 LET B$ = CHR$(65) & UCASE$("x") & STR$(3)
30 LET K = UBOUND(A)
40 OPTION ANGLE DEGREES
50 PRINT B$; K; SIN(30)
60 END
