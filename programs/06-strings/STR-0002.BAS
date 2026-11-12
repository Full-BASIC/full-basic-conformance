1 REM FBCS STR-0002
2 REM CLAIM A-6.1.3-EX
3 REM TYPE SELF
100 REM Examples of 6.1.3: plain, numeric-looking, embedded doubled quote.
110 LET FAIL = 0
120 IF "XYZ" <> "XYZ" THEN LET FAIL = FAIL + 1
130 IF "1E10" <> "1E10" THEN LET FAIL = FAIL + 1
140 IF "He said, ""Don't""." <> "He said, ""Don't""." THEN LET FAIL = FAIL + 1
150 IF LEN("He said, ""Don't"".") <> 17 THEN LET FAIL = FAIL + 1
160 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
170 END
