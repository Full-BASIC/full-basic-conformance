1 REM FBCS STR-0041
2 REM CLAIM E-3102
3 REM TYPE SELF
100 REM Reading a string variable before it has ever been assigned is reported
110 REM as nonfatal 3102 (recommended, l.12848): a handler can intercept it.
120 WHEN EXCEPTION IN
130   LET X = LEN(Z$)
140   PRINT "*** TEST FAILED: NO EXCEPTION ***"
150 USE
160   IF EXTYPE = 3102 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: EXTYPE ***"; EXTYPE
170 END WHEN
180 END
