1 REM FBCS EXC-0206
2 REM CLAIM A-12.2.4-TR102
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9121 with 4.2.4 l.1365-1371 case 2 and 12.1.4 l.8790-8806: a line whose
5 REM execution raises an exception that transfers control to a handler interrupts the sequential
6 REM order, so it is reported together with the first line of the handler (the use-line and the
7 REM handler-line are not executed). Four-digit line numbers tell the reports apart from the
8 REM source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1030 WHEN EXCEPTION IN
1040   CAUSE EXCEPTION 7
1050   LET A = 1
1060 USE
1070   LET E = EXTYPE
1080 END WHEN
1090 WHEN EXCEPTION USE H
1100   CAUSE EXCEPTION 8
1110 END WHEN
1120 LET B = 2
1130 HANDLER H
1140   LET C = EXTYPE
1150 END HANDLER
1160 TRACE OFF
1170 CLOSE #1
1180 OPEN #1: NAME "t.txt", ACCESS INPUT
1190 LET F1 = 0
1200 LET F2 = 0
1210 LET F3 = 0
1220 FOR K = 1 TO 80
1230   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1240   IF POS(L$, "1040") > 0 AND POS(L$, "1070") > 0 THEN LET F1 = 1
1250   IF POS(L$, "1100") > 0 AND POS(L$, "1140") > 0 THEN LET F2 = 1
1260   IF POS(L$, "1050") > 0 OR POS(L$, "1060") > 0 THEN LET F3 = F3 + 1
1270 NEXT K
1280 IF F1 = 1 AND F2 = 1 AND F3 = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3
1290 END
