1 REM FBCS EXC-0133
2 REM CLAIM A-12.2.4-TR95B
3 REM TYPE SELF
4 REM STD 12.2.4 l.9117-9121 with 9.2.4 l.4637-4640 and 9.1.4.2 l.4366-4369: when execution
5 REM reaches an internal-sub-line or an internal-function-line it proceeds to the line after the
6 REM associated END SUB or END FUNCTION, a line that interrupts the sequential order, so the
7 REM trace reports both line numbers and nothing from the body, which is not executed.
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1020 SUB S
1030   LET W = 1
1040 END SUB
1050 FUNCTION F(X)
1060   LET F = X
1070 END FUNCTION
1080 LET Z = 3
1090 TRACE OFF
1100 CLOSE #1
1110 OPEN #1: NAME "t.txt", ACCESS INPUT
1120 LET F1 = 0
1130 LET F2 = 0
1140 LET F3 = 0
1150 FOR K = 1 TO 80
1160   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1170   IF POS(L$, "1020") > 0 AND POS(L$, "1050") > 0 THEN LET F1 = 1
1180   IF POS(L$, "1050") > 0 AND POS(L$, "1080") > 0 THEN LET F2 = 1
1190   IF POS(L$, "1030") > 0 OR POS(L$, "1060") > 0 THEN LET F3 = F3 + 1
1200 NEXT K
1210 IF F1 = 1 AND F2 = 1 AND F3 = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3
1220 END
