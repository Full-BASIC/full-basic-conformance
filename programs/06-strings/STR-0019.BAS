1 REM FBCS STR-0019
2 REM CLAIM A-6.3.2-03
3 REM TYPE REJECT
100 REM A string function must be defined or declared in a lower-numbered line
110 REM than its first reference; using it before the DEF must be rejected.
120 PRINT "EXECUTED"
130 LET X$ = F$("a")
140 DEF F$(A$) = A$
150 END
