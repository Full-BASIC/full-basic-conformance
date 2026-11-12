1 REM FBCS STR-0059
2 REM CLAIM D-6.6-1
3 REM TYPE SELF
100 REM Collating sequence under OPTION COLLATE NATIVE (implementation-defined):
110 REM the host's own byte-wise ordering (ASCII/UTF-8), identical to Table 8
120 REM over the ASCII range.
130 OPTION COLLATE NATIVE
140 LET FAIL = 0
150 IF NOT ("A" < "Z") THEN LET FAIL = FAIL + 1
160 IF NOT ("A" < "a") THEN LET FAIL = FAIL + 1
170 IF NOT ("Z" < "a") THEN LET FAIL = FAIL + 1
180 IF NOT ("0" < "9") THEN LET FAIL = FAIL + 1
190 IF NOT ("9" < "A") THEN LET FAIL = FAIL + 1
200 IF NOT (" " < "!") THEN LET FAIL = FAIL + 1
210 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
220 END
