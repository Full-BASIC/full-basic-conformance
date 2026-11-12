1 REM FBCS EXC-0102
2 REM CLAIM A-12.2.4-TR88A
3 REM TYPE SELF
4 REM STD 12.2.4 l.9073-9079, l.9117-9127 with 4.2.2 prod. 4-6 and 23 (l.1193-1198, l.1313):
5 REM an internal SUB, an internal FUNCTION and a handler are not program-units, so they
6 REM share the debugging and tracing status of the unit that contains them and the lines of
7 REM their bodies are traced like any other line. The values reported are told apart from the
8 REM source text because each one is computed from a variable.
100 OPEN #1: NAME "t.txt", ACCESS OUTPUT
110 LET V1 = 7100
120 LET V2 = 7200
130 LET V3 = 7300
140 SUB S
150   LET W = V1 + 1
160 END SUB
170 FUNCTION F(X)
180   LET G = X + V2
190   LET F = G + 5
200 END FUNCTION
210 DEBUG ON
220 TRACE ON TO #1
230 CALL S
240 LET Z = F(1)
250 WHEN EXCEPTION IN
260   LET Q = 1/0
270 USE
280   LET E = V3 + 1
290 END WHEN
300 TRACE OFF
310 CLOSE #1
320 OPEN #1: NAME "t.txt", ACCESS INPUT
330 LET FS = 0
340 LET FF = 0
350 LET FH = 0
360 FOR K = 1 TO 60
370   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
380   IF POS(L$, "7101") > 0 THEN LET FS = 1
390   IF POS(L$, "7201") > 0 THEN LET FF = 1
400   IF POS(L$, "7301") > 0 THEN LET FH = 1
410 NEXT K
420 IF FS = 1 AND FF = 1 AND FH = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; FS; FF; FH
430 END
