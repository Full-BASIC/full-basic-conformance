1 REM FBCS STR-0010
2 REM CLAIM A-6.2.4-03
3 REM TYPE SELF
100 REM A$(M:N) is the substring from the Mth through the Nth character (1-based).
110 REM Standard example: A$ = "1234" (l.2453).
120 LET FAIL = 0
130 LET A$ = "1234"
140 IF A$(1:1) <> "1" THEN LET FAIL = FAIL + 1
150 IF A$(1:3) <> "123" THEN LET FAIL = FAIL + 1
160 IF A$(2:4) <> "234" THEN LET FAIL = FAIL + 1
170 IF A$(4:4) <> "4" THEN LET FAIL = FAIL + 1
180 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
190 END
