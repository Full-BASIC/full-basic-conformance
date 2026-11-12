1 REM FBCS GFX-0177
2 REM CLAIM A-13.5.2-TR89
3 REM TYPE REJECT
4 REM STD 13.5.2 l.10564-10565: all numeric-arrays of a transform-assignment, the receiving array included, are two-dimensional.
100 PRINT "EXECUTED"
110 DIM V(4)
120 MAT V = SHIFT(1, 2)
130 END
