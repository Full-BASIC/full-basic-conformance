1 REM FBCS SEG-0331
2 REM CLAIM A-9.1.4.1-02
3 REM TYPE SELF
100 REM Redimensioning the formal array of an external function
110 REM does not redimension the actual array (9.1.4.1 passes it by value)
120 DECLARE EXTERNAL FUNCTION G
130 DIM A(5)
140 MAT A = CON
150 LET R = G(A)
160 IF R = 2 AND SIZE(A) = 5 AND A(5) = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; R; SIZE(A)
170 END
200 EXTERNAL FUNCTION G(V())
210 MAT V = ZER(2)
220 LET G = SIZE(V)
230 END FUNCTION
