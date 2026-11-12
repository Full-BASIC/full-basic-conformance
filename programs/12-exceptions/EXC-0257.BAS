1 REM FBCS EXC-0257
2 REM CLAIM A-12.1.4-CL13
3 REM TYPE SELF
10 REM CONTINUE inside a GOSUB subroutine (STD 12.1.4 l.8820-8828): control passes to the
20 REM statement that follows the one that caused the exception, in the subroutine; the RETURN
30 REM returns to the line after the GOSUB.
100 LET T$ = ""
110 WHEN EXCEPTION IN
120   GOSUB 300
130   LET T$ = T$ & "B"
140 USE
150   LET T$ = T$ & "H"
160   CONTINUE
170 END WHEN
180 IF T$ = "SHAB" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; T$
190 STOP
300 LET T$ = T$ & "S"
310 LET A = 1/0
315 LET T$ = T$ & "A"
320 RETURN
330 END
