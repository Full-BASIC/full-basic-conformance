1 REM FBCS EXC-0134
2 REM CLAIM A-12.2.4-TR95C
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9127 with 8.4.4 l.4036-4050: the select-line is executed once and goes
5 REM to the case-line whose case-list matches, which is executed once; the other case-lines
6 REM are not executed. Four-digit line numbers tell the reports apart from the source text.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1020 LET X = 2
1030 SELECT CASE X
1040 CASE 1
1050   LET Y = 0
1060 CASE 2
1070   LET Y = 1
1080 CASE ELSE
1090   LET Y = 9
1100 END SELECT
1110 TRACE OFF
1120 CLOSE #1
1130 OPEN #1: NAME "t.txt", ACCESS INPUT
1140 LET S = 0
1150 LET C2 = 0
1160 LET C1 = 0
1170 LET J = 0
1180 FOR K = 1 TO 80
1190   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1200   IF POS(L$, "SELECT CASE") > 0 THEN LET S = S + 1
1210   IF POS(L$, "CASE 2") > 0 THEN LET C2 = C2 + 1
1220   IF POS(L$, "CASE 1") > 0 OR POS(L$, "CASE ELSE") > 0 THEN LET C1 = C1 + 1
1230   IF POS(L$, "1030") > 0 AND POS(L$, "1060") > 0 THEN LET J = 1
1240 NEXT K
1250 IF S = 1 AND C2 = 1 AND C1 = 0 AND J = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; S; C2; C1; J
1260 END
