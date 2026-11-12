1 REM FBCS EXC-0207
2 REM CLAIM A-12.2.4-TR111
3 REM TYPE SELF
4 REM STD 12.2.4 l.9073-9080 and l.9119-9126 with 12.1.4 l.8887-8908: an exception raised in an
5 REM external SUB without debugging, handled by the handler of the calling unit, interrupts the
6 REM sequential order of the caller at its CALL line, so the caller reports the CALL line and the
7 REM first line of the handler; the SUB, which has no debugging, reports nothing. Four-digit line
8 REM numbers tell the reports apart from the source text.
900 DECLARE EXTERNAL SUB S
1000 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1005 DEBUG ON
1010 TRACE ON TO #1
1030 WHEN EXCEPTION IN
1040   CALL S
1050 USE
1060   LET E = EXTYPE
1070 END WHEN
1080 TRACE OFF
1090 CLOSE #1
1100 OPEN #1: NAME "t.txt", ACCESS INPUT
1110 LET F1 = 0
1120 LET F2 = 0
1130 FOR K = 1 TO 80
1140   LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
1150   IF POS(L$, "1040") > 0 AND POS(L$, "1060") > 0 THEN LET F1 = 1
1160   IF POS(L$, "2010") > 0 AND POS(L$, "1060") > 0 THEN LET F2 = 1
1170 NEXT K
1180 IF F1 = 1 AND F2 = 0 AND E = 103001 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; E
1190 END
2000 EXTERNAL SUB S
2010 LET Q = 1/0
2020 END SUB
