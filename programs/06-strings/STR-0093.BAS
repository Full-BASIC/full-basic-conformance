1 REM FBCS STR-0093
2 REM CLAIM D-4.1-1
3 REM TYPE SELF
4 REM Other-characters are one position each (Latin-1 here): LEN and substrings count
5 REM characters, not bytes, also for characters read from DATA without quotes.
100 LET A$ = "ñandú á"
110 LET FAIL = 0
120 IF LEN(A$) <> 7 THEN LET FAIL = FAIL + 1
130 IF A$(1:1) <> "ñ" THEN LET FAIL = FAIL + 1
140 IF A$(2:3) <> "an" THEN LET FAIL = FAIL + 1
150 IF A$(5:5) <> "ú" THEN LET FAIL = FAIL + 1
160 IF A$(7:7) <> "á" THEN LET FAIL = FAIL + 1
170 IF A$(1:5) <> "ñandú" THEN LET FAIL = FAIL + 1
180 LET B$ = A$ & "¿?"
190 IF LEN(B$) <> 9 THEN LET FAIL = FAIL + 1
200 IF LEN("ÑANDÚ") <> 5 OR LEN("©") <> 1 OR LEN("ÿ") <> 1 THEN LET FAIL = FAIL + 1
210 READ D$, E$
220 IF LEN(D$) <> 5 OR D$ <> "ñandú" THEN LET FAIL = FAIL + 1
230 IF LEN(E$) <> 5 OR E$(1:1) <> "¿" THEN LET FAIL = FAIL + 1
240 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: "; FAIL
250 DATA ñandú, "¿qué?"
260 END
