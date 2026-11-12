1 REM FBCS ARR-0231
2 REM CLAIM A-7.3.2-TR89
3 REM TYPE REJECT
4 REM STD 7.3.2 l.3373-3375 with 2.3 l.580-584: a MAT assignment between arrays of different dimensionality is rejected at load.
100 PRINT "EXECUTED"
110 DIM A$(2,2), B$(3)
120 MAT A$ = B$
130 END
