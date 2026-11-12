1 REM FBCS EXC-0104
2 REM CLAIM A-12.2.4-TR88C
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9123 (a line that interrupts the sequential order reports its own line
5 REM number and that of the next line to be executed) with 8.3.4 l.3837-3841 and l.3862-3865:
6 REM CALL goes to the first line of the SUB body, END SUB returns to the line after the CALL,
7 REM LOOP resumes at the do-line, EXIT DO continues at the line after the loop-line and EXIT FOR
8 REM at the line after the next-line. The line numbers have four digits and none of these
9 REM statements names its target, so a report that holds both numbers is not the source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1010 SUB S
1020   LET W = 1
1030 END SUB
1040 DEBUG ON
1050 TRACE ON TO #1
1060 CALL S
1070 LET N = 0
1080 DO
1090   LET N = N + 1
1100   IF N = 2 THEN EXIT DO
1110 LOOP
1120 FOR I = 1 TO 3
1130   IF I = 2 THEN EXIT FOR
1140 NEXT I
1150 TRACE OFF
1160 CLOSE #1
1170 OPEN #1: NAME "t.txt", ACCESS INPUT
1180 LET F1 = 0
1190 LET F2 = 0
1200 LET F3 = 0
1210 LET F4 = 0
1220 LET F5 = 0
1230 FOR K = 1 TO 80
1240   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1250   IF POS(L$, "1060") > 0 AND POS(L$, "1020") > 0 THEN LET F1 = 1
1260   IF POS(L$, "1030") > 0 AND POS(L$, "1070") > 0 THEN LET F2 = 1
1270   IF POS(L$, "1110") > 0 AND POS(L$, "1080") > 0 THEN LET F3 = 1
1280   IF POS(L$, "1100") > 0 AND POS(L$, "1120") > 0 THEN LET F4 = 1
1290   IF POS(L$, "1130") > 0 AND POS(L$, "1150") > 0 THEN LET F5 = 1
1300 NEXT K
1310 IF F1 + F2 + F3 + F4 + F5 = 5 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3; F4; F5
1320 END
