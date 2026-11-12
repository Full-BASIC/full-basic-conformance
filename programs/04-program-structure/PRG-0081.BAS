1 REM FBCS PRG-0081
2 REM CLAIM D-4.1-1
3 REM TYPE SELF
4 REM STD 4.1.6 l.1162-1167 (D-4.1-1): the e-acute is one other-character at ordinal
5 REM position 233 (ISO 8859-1, 0xE9), so ORD of it is 233; ORD of a string of more
6 REM than one character is still exception 4003.
100 LET OK = 1
110 IF ORD("é") <> 233 THEN LET OK = 0
120 IF ORD("é") <> ORD(CHR$(233)) THEN LET OK = 0
130 WHEN EXCEPTION IN
140 LET X = ORD("ab")
150 LET OK = 0
160 USE
170 IF EXTYPE <> 4003 THEN LET OK = 0
180 END WHEN
190 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
200 END
