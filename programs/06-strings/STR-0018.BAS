1 REM FBCS STR-0018
2 REM CLAIM A-6.3.2-02
3 REM TYPE REJECT
100 REM An actual array must have as many dimensions as the formal parameter.
110 PRINT "EXECUTED"
120 DIM A$(2,2)
130 DEF F$(B$()) = B$(1,1)
140 LET X$ = F$(A$)
150 END
