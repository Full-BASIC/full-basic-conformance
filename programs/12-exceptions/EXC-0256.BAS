1 REM FBCS EXC-0256
2 REM CLAIM A-12.1.4-CL13
3 REM TYPE SELF
10 REM RETRY inside a GOSUB subroutine (STD 12.1.4 l.8829-8835): the line that caused the
20 REM exception is executed again, the RETURN returns to the line after the GOSUB.
100 LET N = 0
110 LET T$ = ""
120 WHEN EXCEPTION IN
130   GOSUB 300
140   LET T$ = T$ & "B"
150 USE
160   LET N = N + 1
170   LET T$ = T$ & "H"
180   RETRY
190 END WHEN
200 IF T$ = "SHOB" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; T$
210 STOP
300 LET T$ = T$ & "S"
310 LET A = 1/N
315 LET T$ = T$ & "O"
320 RETURN
330 END
