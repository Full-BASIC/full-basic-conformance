1 REM FBCS ARR-0233
2 REM CLAIM A-7.3.2-TR89
3 REM TYPE REJECT
4 REM STD 7.3.2 l.3376-3379: two string-arrays being concatenated have the same number of dimensions.
100 PRINT "EXECUTED"
110 DIM A$(2), B$(2,2)
120 MAT A$ = A$ & B$
130 END
