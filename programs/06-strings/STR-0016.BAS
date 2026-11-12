1 REM FBCS STR-0016
2 REM CLAIM A-6.3.2-01
3 REM TYPE REJECT
100 REM Wrong NUMBER of arguments in a string-function-ref must be rejected.
110 PRINT "EXECUTED"
120 DEF F$(A$) = A$
130 LET X$ = F$("a", "b")
140 END
