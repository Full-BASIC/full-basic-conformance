1 REM FBCS EXC-0193
2 REM CLAIM A-12.1.2-TR98
3 REM TYPE SELF
4 REM STD 12.1.2 l.8701-8706, 12.1.4 l.8860-8863: handler-line is outside the handler: GOSUB may name it;
5 REM control then continues after the end-handler-line, so the handler body does not run.
100 LET F = 0
110 GOSUB 150
120 LET F = 9
150 HANDLER H
160   LET F = 9
170 END HANDLER
180 IF F = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
