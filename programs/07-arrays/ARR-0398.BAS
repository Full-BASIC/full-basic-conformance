1 REM FBCS ARR-0398
2 REM CLAIM A-7.2.4.3-TR178
3 REM TYPE OUTPUT
4 REM STD 7.2.5 l.3306-3310 (6005), 5.2.4: the redim indices are rounded before the bounds are checked: ZER(.4) has
5 REM upper bound 0 below the default lower bound 1 (6005), CON(1.5 TO .6) has bounds 2 and 1 (6005), ZER(.5) has
6 REM upper bound 1.
10 DIM V(5)
20 WHEN EXCEPTION IN
30   MAT V = ZER(.4)
40   PRINT "NOEXC"
50 USE
60   PRINT EXTYPE
70 END WHEN
80 WHEN EXCEPTION IN
90   MAT V = CON(1.5 TO .6)
100   PRINT "NOEXC"
110 USE
120   PRINT EXTYPE
130 END WHEN
140 MAT V = ZER(.5)
150 PRINT SIZE(V)
160 END
