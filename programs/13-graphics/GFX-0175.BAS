1 REM FBCS GFX-0175
2 REM CLAIM A-13.3.2-TR89
3 REM TYPE REJECT
4 REM STD 13.3.2 l.9848-9850: two arrays in an array-point-list are both one-dimensional; two matrices are rejected at load.
100 PRINT "EXECUTED"
110 DIM M(3,2), N(3,2)
120 MAT M = CON
130 MAT N = CON
140 MAT GRAPH POINTS: M, N
150 END
