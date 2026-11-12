1 REM FBCS STR-0034
2 REM CLAIM A-6.4.4-09
3 REM TYPE SELF
100 REM VAL of a numeric constant whose magnitude underflows yields zero
110 REM (l.2730-2731: VAL("2.E-99") could be zero). Uncaught, our implementation
120 REM reports nonfatal 1504 and continues with zero.
130 LET X = VAL("1E-9999")
140 IF X = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; X
150 END
