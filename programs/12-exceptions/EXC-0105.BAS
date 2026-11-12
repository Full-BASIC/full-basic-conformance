1 REM FBCS EXC-0105
2 REM CLAIM A-12.2.4-TR88D
3 REM TYPE INPUT
4 REM STD 12.2.4 l.9117-9127, l.9139-9143 and 12.2.6 l.9159-9161: every line that assigns a value
5 REM to a variable or to an array element reports the values assigned, whatever the statement:
6 REM MAT INPUT, LINE INPUT, MAT READ, an array assignment (all the new elements) and a LET in an
7 REM external SUB. A report is accepted when ONE record holds the line number (four digits) and
8 REM the value; the values are computed or read, so the source text of the line cannot hold them.
1000 DECLARE EXTERNAL SUB E
1010 OPEN #1: NAME "t.txt", ACCESS OUTPUT
1020 DIM A(2), B(2), C(2), D(2)
1030 LET V = 7600
1035 LET R = 0
1040 DEBUG ON
1050 TRACE ON TO #1
1060 MAT INPUT A
1070 LINE INPUT L$
1080 MAT READ B
1090 DATA 7621, 7622
1100 MAT C = CON
1110 MAT D = (V + 5) * C
1120 TRACE OFF
1130 CLOSE #1
1140 CALL E(R)
1150 OPEN #1: NAME "t.txt", ACCESS INPUT
1160 LET F1 = 0
1170 LET F2 = 0
1180 LET F3 = 0
1190 LET F4 = 0
1200 FOR K = 1 TO 80
1210   LINE INPUT #1, IF MISSING THEN EXIT FOR: T$
1220   IF POS(T$, "1060") > 0 AND POS(T$, "7612") > 0 THEN LET F1 = 1
1230   IF POS(T$, "1070") > 0 AND POS(T$, "hello") > 0 THEN LET F2 = 1
1240   IF POS(T$, "1080") > 0 AND POS(T$, "7622") > 0 THEN LET F3 = 1
1250   IF POS(T$, "1110") > 0 AND POS(T$, "7605") > 0 THEN LET F4 = 1
1260 NEXT K
1270 IF F1 + F2 + F3 + F4 + R = 5 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; F1; F2; F3; F4; R
1280 END
2000 EXTERNAL SUB E(R)
2010   OPEN #1: NAME "t2.txt", ACCESS OUTPUT
2020   LET V = 7700
2030   DEBUG ON
2040   TRACE ON TO #1
2050   LET X = V + 1
2060   TRACE OFF
2070   CLOSE #1
2080   OPEN #1: NAME "t2.txt", ACCESS INPUT
2090   LET R = 0
2100   FOR K = 1 TO 20
2110     LINE INPUT #1, IF MISSING THEN EXIT FOR: L$
2120     IF POS(L$, "2050") > 0 AND POS(L$, "7701") > 0 THEN LET R = 1
2130   NEXT K
2140   CLOSE #1
2150 END SUB
