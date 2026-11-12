1 REM FBCS EXC-0132
2 REM CLAIM A-12.2.4-TR95A
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9121 (a line that interrupts the sequential order reports its own line
5 REM number and that of the next line to be executed) with 12.1.4 l.8851-8859: the use-line of a
6 REM when-use-block reached without an exception goes to the line after the protection-block and
7 REM the end-handler-line of a detached handler goes to the line after the end-when-line, so the
8 REM end-when-lines are not executed and are not reported. Four-digit line numbers tell the
9 REM reports apart from the source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1030 WHEN EXCEPTION IN
1040   LET A = 1
1050 USE
1060   LET E = 9
1070 END WHEN
1080 WHEN EXCEPTION USE H
1090   CAUSE EXCEPTION 7
1100 END WHEN
1110 LET B = 2
1120 HANDLER H
1130   LET C = EXTYPE
1140 END HANDLER
1150 TRACE OFF
1160 CLOSE #1
1170 OPEN #1: NAME "t.txt", ACCESS INPUT
1180 LET F1 = 0
1190 LET F2 = 0
1200 LET F3 = 0
1210 LET F4 = 0
1220 FOR K = 1 TO 80
1230   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1240   IF POS(L$, "1050") > 0 AND POS(L$, "1080") > 0 THEN LET F1 = 1
1250   IF POS(L$, "1140") > 0 AND POS(L$, "1110") > 0 THEN LET F2 = 1
1260   IF POS(L$, "1070") > 0 OR POS(L$, "1100") > 0 OR POS(L$, "1060") > 0 THEN LET F3 = F3 + 1
1270   IF POS(L$, "WHEN EXCEPTION IN") > 0 THEN LET F4 = F4 + 1
1280 NEXT K
1290 IF F1 = 1 AND F2 = 1 AND F3 = 0 AND F4 = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3; F4
1300 END
