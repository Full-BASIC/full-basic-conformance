1 REM FBCS STR-0094
2 REM CLAIM D-4.1-1
3 REM TYPE SELF
4 REM CHR$ and ORD cover the 256 positions 0..255 (ISO 8859-1 here): the character of
5 REM position n and the literal agree, and strings compare by position.
100 LET FAIL = 0
110 FOR I = 128 TO 255
120 IF ORD(CHR$(I)) <> I OR LEN(CHR$(I)) <> 1 THEN LET FAIL = FAIL + 1
130 NEXT I
140 IF CHR$(233) <> "é" OR CHR$(241) <> "ñ" OR CHR$(255) <> "ÿ" OR CHR$(191) <> "¿" THEN LET FAIL = FAIL + 1
150 IF ORD("ñ") <> 241 OR ORD("ÿ") <> 255 OR ORD("¡") <> 161 THEN LET FAIL = FAIL + 1
160 IF NOT ("z" < "ñ") OR NOT ("é" < "ñ") OR NOT ("Á" < "á") THEN LET FAIL = FAIL + 1
170 IF "añb" <= "aza" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: "; FAIL
190 END
