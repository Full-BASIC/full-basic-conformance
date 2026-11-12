1 REM FBCS EXC-0052
2 REM CLAIM A-12.2.4-07
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9127: with tracing on, a line that interrupts the sequential order reports
5 REM its own line number and the number of the next line to be executed, and a line that assigns a
6 REM value reports the value assigned. Line 1050 is a real jump (GOTO 1080); line 1090 is an
7 REM EXIT DO, which continues at the line after the loop-line (8.3.4 l.3862-3865) and does not
8 REM name its target in the source text, so a report holding 1090 and 1110 is a real report. The
9 REM value is computed so it cannot be mistaken for the source text. A NEXT that ends its loop
10 REM does not interrupt the order of lines, so it cannot be used here.
1000 OPEN #3: NAME "t3.txt", ACCESS OUTPUT
1010 LET V = 7900
1020 DEBUG ON
1030 TRACE ON TO #3
1040 LET A = V + 1
1050 GOTO 1080
1060 LET A = 0
1070 PRINT "not reached"
1080 DO
1090   EXIT DO
1100 LOOP
1110 PRINT "done"
1120 TRACE OFF
1130 CLOSE #3
1140 OPEN #3: NAME "t3.txt", ACCESS INPUT
1150 LET VALOK = 0
1160 LET NXT = 0
1170 LET EXD = 0
1180 FOR K = 1 TO 60
1190   LINE INPUT #3, IF MISSING THEN EXIT FOR: L$
1200   IF POS(L$, "1040") > 0 AND POS(L$, "7901") > 0 THEN LET VALOK = 1
1210   IF POS(L$, "1050") > 0 AND POS(L$, "1080") > 0 THEN LET NXT = 1
1220   IF POS(L$, "1090") > 0 AND POS(L$, "1110") > 0 THEN LET EXD = 1
1230 NEXT K
1240 IF VALOK = 1 AND NXT = 1 AND EXD = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; VALOK; NXT; EXD
1250 END
