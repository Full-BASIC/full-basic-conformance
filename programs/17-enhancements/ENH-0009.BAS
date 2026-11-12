1 REM FBCS ENH-0009
2 REM CLAIM A-ENH-10
3 REM TYPE SELF
4 REM UCASE$ and LCASE$ convert the letters of ISO 8859-1 (a-grave..thorn <-> A-grave..THORN,
5 REM except the multiplication and division signs); sharp s and y-diaeresis have no
6 REM one-character counterpart and stay.
100 LET FAIL = 0
110 IF UCASE$("ñandú") <> "ÑANDÚ" THEN LET FAIL = FAIL + 1
120 IF LCASE$("ÑANDÚ") <> "ñandú" THEN LET FAIL = FAIL + 1
130 IF UCASE$("áéíóúüñç") <> "ÁÉÍÓÚÜÑÇ" THEN LET FAIL = FAIL + 1
140 IF LCASE$("ÁÉÍÓÚÜÑÇ") <> "áéíóúüñç" THEN LET FAIL = FAIL + 1
150 IF ORD(UCASE$("à")) <> 192 OR ORD(LCASE$("Þ")) <> 254 THEN LET FAIL = FAIL + 1
160 IF UCASE$("ß") <> "ß" OR UCASE$("ÿ") <> "ÿ" OR LCASE$("ß") <> "ß" THEN LET FAIL = FAIL + 1
170 IF UCASE$("×÷¿") <> "×÷¿" OR LCASE$("×÷¿") <> "×÷¿" THEN LET FAIL = FAIL + 1
180 IF LEN(UCASE$("áéíóú")) <> 5 THEN LET FAIL = FAIL + 1
190 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: "; FAIL
200 END
