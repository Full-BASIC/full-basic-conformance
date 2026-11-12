1 REM FBCS ARR-0232
2 REM CLAIM A-7.3.2-TR89
3 REM TYPE REJECT
4 REM STD 7.3.2 l.3373-3375: the value of B$ & C$ is one-dimensional, the target two-dimensional.
100 PRINT "EXECUTED"
110 DIM A$(2,2), B$(3), C$(3)
120 MAT A$ = B$ & C$
130 END
