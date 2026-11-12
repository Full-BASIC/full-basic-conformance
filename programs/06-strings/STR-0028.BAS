1 REM FBCS STR-0028
2 REM CLAIM A-6.4.4-01
3 REM TYPE SELF
100 REM CHR$(M): M >= 0 and < size of declared character set; CHR$(0) is the
110 REM first character of the collating sequence. Standard: CHR$(53)="5",
120 REM CHR$(65)="A" (Table 8).
130 LET FAIL = 0
140 IF CHR$(53) <> "5" THEN LET FAIL = FAIL + 1
150 IF CHR$(65) <> "A" THEN LET FAIL = FAIL + 1
160 IF ORD(CHR$(0)) <> 0 THEN LET FAIL = FAIL + 1
170 IF LEN(CHR$(0)) <> 1 THEN LET FAIL = FAIL + 1
180 IF ORD(CHR$(65)) <> 65 THEN LET FAIL = FAIL + 1
190 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
200 END
