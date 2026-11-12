1 REM FBCS GFX-0181
2 REM CLAIM A-13.4.2-TR94
3 REM TYPE REJECT
4 REM STD 13.4.2 l.10160-10162: a numeric-variable-matrix V(?,) over a one-dimensional array is rejected at load.
100 PRINT "EXECUTED"
110 DIM V(3)
120 MAT LOCATE POINT: V(?,)
130 END
