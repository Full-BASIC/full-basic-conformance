1 REM FBCS STR-0013
2 REM CLAIM D-6.2-1
3 REM TYPE SELF
100 REM Initial value of a string variable (implementation-defined): reading it
110 REM before assignment raises nonfatal 3102; uncaught, the value used is "".
120 LET FAIL = 0
130 LET OK3102 = 0
140 WHEN EXCEPTION IN
150   LET X = LEN(Z$)
160   LET NOEXC = 1
170 USE
180   IF EXTYPE = 3102 THEN LET OK3102 = 1
190 END WHEN
200 IF OK3102 = 0 THEN LET FAIL = FAIL + 1
210 LET N = LEN(Z$)
220 IF N <> 0 THEN LET FAIL = FAIL + 1
230 IF Z$ <> "" THEN LET FAIL = FAIL + 1
240 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
250 END
