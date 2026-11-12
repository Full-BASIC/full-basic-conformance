1 REM FBCS SEG-0332
2 REM CLAIM A-9.1.4.1-03
3 REM TYPE SELF
100 REM The formal array starts with the bounds and the values of the
110 REM actual array (a copy: 9.1.4.1 l.4309-4316)
120 OPTION BASE 0
130 DIM A(2), B$(1 TO 2)
140 LET A(0) = 7
150 LET A(2) = 9
160 LET B$(2) = "xy"
170 DECLARE FUNCTION F
180 LET R = F(A, B$)
190 IF R = 7 + 9 + 3 + 2 AND B$(2) = "xy" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; R
200 FUNCTION F(V(), W$())
210 LET F = V(0) + V(2) + SIZE(V) + LEN(W$(2))
220 LET W$(2) = "changed"
230 END FUNCTION
240 END
