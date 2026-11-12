1 REM FBCS STR-0057
2 REM CLAIM D-6.4-2
3 REM TYPE SELF
100 REM ORD for the native character set (implementation-defined): on this host
110 REM the native collating sequence is ASCII byte order, so ORD("A")=65.
120 OPTION COLLATE NATIVE
130 LET FAIL = 0
140 IF ORD("A") <> 65 THEN LET FAIL = FAIL + 1
150 IF ORD("a") <> 97 THEN LET FAIL = FAIL + 1
160 IF ORD("5") <> 53 THEN LET FAIL = FAIL + 1
170 IF ORD(" ") <> 32 THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
