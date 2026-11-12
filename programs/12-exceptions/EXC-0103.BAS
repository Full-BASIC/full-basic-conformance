1 REM FBCS EXC-0103
2 REM CLAIM A-12.2.4-TR88B
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9127 with 8.2.4: GOSUB, ON GOSUB and RETURN do not leave the program-unit,
5 REM so tracing stays on after them: the lines of the subroutine, the line after the GOSUB and the
6 REM later lines are all reported, and the RETURN line reports the line it returns to (the line
7 REM numbers have four digits and the values are computed so that no report can be mistaken for
8 REM the source text).
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1010 LET V = 7400
1020 DEBUG ON
1030 TRACE ON TO #1
1040 GOSUB 2300
1050 LET A = V + 1
1060 ON 1 GOSUB 2400
1070 LET B = V + 2
1080 TRACE OFF
1090 CLOSE #1
1100 OPEN #1: NAME "t.txt", ACCESS INPUT
1110 LET FA = 0
1120 LET FB = 0
1130 LET FC = 0
1140 LET FD = 0
1150 LET FR1 = 0
1160 LET FR2 = 0
1170 FOR K = 1 TO 60
1180   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1190   IF POS(L$, "7401") > 0 THEN LET FA = 1
1200   IF POS(L$, "7402") > 0 THEN LET FB = 1
1210   IF POS(L$, "7403") > 0 THEN LET FC = 1
1220   IF POS(L$, "7404") > 0 THEN LET FD = 1
1230   IF POS(L$, "2310") > 0 AND POS(L$, "1050") > 0 THEN LET FR1 = 1
1240   IF POS(L$, "2410") > 0 AND POS(L$, "1070") > 0 THEN LET FR2 = 1
1250 NEXT K
1260 LET S = FA + FB + FC + FD + FR1 + FR2
1265 IF S = 6 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; FA; FB; FC; FD; FR1; FR2
1270 STOP
2300 LET C = V + 3
2310 RETURN
2400 LET D = V + 4
2410 RETURN
2500 END
