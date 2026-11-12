1 REM FBCS PRG-0043
2 REM CLAIM A-4.3.4-01
3 REM TYPE SELF
100 LET X = 1
110 REM this remark line has no effect
120 ! a null statement line
130 LET X = X + 1
140 IF X = 2 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
150 END
