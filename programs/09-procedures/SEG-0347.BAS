1 REM FBCS SEG-0347
2 REM CLAIM D-9.1-1
3 REM TYPE SELF
100 REM A string-array parameter of a function has the default maximum
110 REM length, not the one of the actual array (9.1.4.1 l.4316-4319); the actual keeps its own
120 DECLARE STRING L$(2)*4
130 DECLARE FUNCTION F
140 LET R = F(L$)
150 IF R = 8 AND LEN(L$(1)) = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; R
160 FUNCTION F(M$())
170 LET M$(1) = "ABCDEFGH"
180 LET F = LEN(M$(1))
190 END FUNCTION
200 END
