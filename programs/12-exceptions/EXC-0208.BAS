1 REM FBCS EXC-0208
2 REM CLAIM A-12.2.4-TR111
3 REM TYPE SELF
4 REM STD 12.2.4 l.9123-9126 with 12.1.4 l.8790-8806: when the first line of an exception-handler is
5 REM a remark-line, that line is the next line to be executed and the jump to the handler reports it,
6 REM for a handler in line and for a detached handler. Four-digit line numbers tell the reports
7 REM apart from the source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1030 WHEN EXCEPTION IN
1040   CAUSE EXCEPTION 7
1050 USE
1060   REM first line of the handler
1070   LET E = EXTYPE
1080 END WHEN
1090 WHEN EXCEPTION USE H
1100   CAUSE EXCEPTION 8
1110 END WHEN
1120 LET B = 2
1130 HANDLER H
1140   REM first line of the handler
1150   LET C = EXTYPE
1160 END HANDLER
1170 TRACE OFF
1180 CLOSE #1
1190 OPEN #1: NAME "t.txt", ACCESS INPUT
1200 LET F1 = 0
1210 LET F2 = 0
1220 LET F3 = 0
1230 FOR K = 1 TO 80
1240   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1250   IF POS(L$, "1040") > 0 AND POS(L$, "1060") > 0 THEN LET F1 = 1
1260   IF POS(L$, "1100") > 0 AND POS(L$, "1140") > 0 THEN LET F2 = 1
1270   IF POS(L$, "1040") > 0 AND POS(L$, "1070") > 0 THEN LET F3 = F3 + 1
1280   IF POS(L$, "1100") > 0 AND POS(L$, "1150") > 0 THEN LET F3 = F3 + 1
1290 NEXT K
1300 IF F1 = 1 AND F2 = 1 AND F3 = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3
1310 END
