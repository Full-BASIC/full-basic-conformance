1 REM FBCS STR-0044
2 REM CLAIM A-6.5.4-02
3 REM TYPE SELF
100 REM Assigning to a substring-qualified target replaces exactly that portion;
110 REM the string may grow or shrink. Standard examples (l.2808-2809) with
120 REM A$ = "1234".
130 LET FAIL = 0
140 LET A$ = "1234"
150 LET A$(2:3) = "32"
160 IF A$ <> "1324" THEN LET FAIL = FAIL + 1
170 LET A$ = "1234"
180 LET A$(2:3) = ""
190 IF A$ <> "14" THEN LET FAIL = FAIL + 1
200 LET A$ = "1234"
210 LET A$(2:3) = A$(1:2)
220 IF A$ <> "1124" THEN LET FAIL = FAIL + 1
230 LET A$ = "1234"
240 LET A$(2:1) = "5"
250 IF A$ <> "15234" THEN LET FAIL = FAIL + 1
260 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
270 END
