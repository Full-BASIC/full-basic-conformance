1 REM FBCS STR-0017
2 REM CLAIM A-6.3.2-01
3 REM TYPE REJECT
100 REM Wrong TYPE of an argument in a string-function-ref must be rejected.
110 PRINT "EXECUTED"
120 DEF F$(A$) = A$
130 LET X$ = F$(1)
140 END
