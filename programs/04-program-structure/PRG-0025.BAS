1 REM FBCS PRG-0025
2 REM CLAIM D-4.1-1
3 REM TYPE SELF
4 REM STD 4.1.6 l.1162-1167 and Table 8: each other-character is one position (here Latin-1,
5 REM ISO 8859-1), so a string with an e-acute has length 1, not 2.
100 LET E$ = "é"
110 LET OK = 1
120 IF LEN(CHR$(233)) <> 1 OR ORD(CHR$(233)) <> 233 THEN LET OK = 0
130 IF LEN(E$) <> 1 THEN LET OK = 0
140 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
150 END
