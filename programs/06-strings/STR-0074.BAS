1 REM FBCS STR-0074
2 REM CLAIM A-6.4.2-TR89
3 REM TYPE REJECT
4 REM STD 6.4.2 production 3: MAXLEN (simple-string-variable / string-array); a string constant is not one.
100 PRINT "EXECUTED"
110 PRINT MAXLEN("abc")
120 END
