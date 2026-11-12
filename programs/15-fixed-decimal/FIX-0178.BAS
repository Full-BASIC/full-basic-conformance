1 REM FBCS FIX-0178
2 REM CLAIM D-15.1-7
3 REM TYPE SELF
4 REM STD 15.1.4 l.12236-12244 only says that the value assigned is rounded; FullBASIC rounds half away
5 REM from zero, so a negative midpoint rounds to the larger magnitude, like a positive one.
100 OPTION ARITHMETIC FIXED *8.2
110 LET OK = 1
120 LET A = -1.555
130 LET B = 1.555
140 LET C = -1.545
150 LET D = -0.005
160 IF A <> -1.56 THEN LET OK = 0
170 IF B <> 1.56 THEN LET OK = 0
180 IF C <> -1.55 THEN LET OK = 0
190 IF D <> -0.01 THEN LET OK = 0
200 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
210 END
