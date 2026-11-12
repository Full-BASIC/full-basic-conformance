1 REM FBCS EXC-0264
2 REM CLAIM D-2.4-2
3 REM TYPE SELF
4 REM 2.4 l.591-597, 12.1.4 l.8909-8913: an endless recursion reaches a resource-constraint exception that a
5 REM when-block can catch; its EXTYPE is that of a local enhancement (negative) and the program goes on.
100 FUNCTION D(N)
110   LET D = 1 + D(N + 1)
120 END FUNCTION
130 LET OK = 0
200 WHEN EXCEPTION IN
210   PRINT D(0)
220 USE
230   IF EXTYPE < 0 THEN LET OK = 1
240 END WHEN
800 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
810 END
