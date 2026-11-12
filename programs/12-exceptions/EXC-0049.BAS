1 REM FBCS EXC-0049
2 REM CLAIM A-12.2.4-05
3 REM TYPE SELF
4 REM STD 12.2.4 l.9106-9113: TRACE ON and TRACE OFF act on the program-unit that contains them and
5 REM tracing is off "upon each separate entry to a program-unit". An external SUB is a program-unit,
6 REM so its lines are not traced even if the caller is tracing; an internal SUB is not (4.2.2
7 REM prod. 23 l.1313), so it is traced as part of its unit. After the call the caller still traces
8 REM and TRACE OFF stops it. A trace report holds the value assigned (l.9139-9143); the values
9 REM are computed, so no report can be mistaken for the source text.
100 DECLARE EXTERNAL SUB S
110 OPEN #1: NAME "t.txt", ACCESS OUTPUT
120 LET A = 7800
130 SUB I
140   LET G = A + 6
150 END SUB
160 DEBUG ON
170 TRACE ON TO #1
180 LET B = A + 1
190 CALL S
200 LET C = A + 2
210 CALL I
220 TRACE OFF
230 LET D = A + 4
240 CLOSE #1
250 OPEN #1: NAME "t.txt", ACCESS INPUT
260 LET N1 = 0
270 LET NS = 0
280 LET N2 = 0
290 LET NI = 0
300 LET ND = 0
310 FOR K = 1 TO 60
320   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
330   IF POS(L$, "7801") > 0 THEN LET N1 = 1
340   IF POS(L$, "7002") > 0 THEN LET NS = 1
350   IF POS(L$, "7802") > 0 THEN LET N2 = 1
360   IF POS(L$, "7806") > 0 THEN LET NI = 1
370   IF POS(L$, "7804") > 0 THEN LET ND = 1
380 NEXT K
390 LET OK = 0
392 IF N1 = 1 AND N2 = 1 AND NI = 1 AND NS = 0 AND ND = 0 THEN LET OK = 1
394 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; N1; N2; NI; NS; ND
400 END
500 EXTERNAL SUB S
510   DEBUG ON
520   LET U = 7000 + 2
530 END SUB
