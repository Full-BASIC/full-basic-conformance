1 REM FBCS EXC-0210
2 REM CLAIM A-12.2.4-TR125
3 REM TYPE SELF
4 REM STD 12.2.4 l.9119-9126 with 12.1.4 l.8842-8851: an inner handler leaves by EXIT HANDLER to the
5 REM handler of the enclosing WHEN of the same unit; that line interrupts the sequential order, so it
6 REM is reported together with the first line of the outer handler (1110), not with its use-line
7 REM (1100), which is not executed. Four-digit line numbers tell the reports from the source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1020 WHEN EXCEPTION IN
1030   WHEN EXCEPTION IN
1040     CAUSE EXCEPTION 9
1050   USE
1060     EXIT HANDLER
1070   END WHEN
1100 USE
1110   LET E = EXTYPE
1120 END WHEN
1130 TRACE OFF
1140 CLOSE #1
1150 OPEN #1: NAME "t.txt", ACCESS INPUT
1160 LET F1 = 0
1170 LET F2 = 0
1180 FOR K = 1 TO 80
1190   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1200   IF POS(L$, "1060") > 0 AND POS(L$, "1110") > 0 THEN LET F1 = 1
1210   IF POS(L$, "1100") > 0 THEN LET F2 = 1
1220 NEXT K
1230 IF F1 = 1 AND F2 = 0 AND E = 9 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; E
1240 END
