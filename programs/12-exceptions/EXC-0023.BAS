1 REM FBCS EXC-0023
2 REM CLAIM A-12.1.3-EX
3 REM TYPE INPUT
100 OPEN #9: NAME "exists.txt", ACCESS OUTPUT
110 PRINT #9: "data"
120 CLOSE #9
130 HANDLER file_trouble
140   LET file_ok$ = "false"
150   IF EXTYPE = 7107 THEN
160     LET message$ = " doesn't exist"
170   ELSE
180     LET message$ = " couldn't be used"
190   END IF
200   PRINT "file "; filename$; message$; " try again"
210 END HANDLER
220 LET file_ok$ = "true"
230 DO
240   INPUT filename$
250   LET file_ok$ = "true"
260   WHEN EXCEPTION USE file_trouble
270     OPEN #1: NAME filename$, ACCESS INPUT
280   END WHEN
290 LOOP UNTIL file_ok$ = "true"
300 IF filename$ = "exists.txt" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; filename$
310 END
