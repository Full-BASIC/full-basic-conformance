1 REM FBCS STR-0046
2 REM CLAIM A-6.6.2-01
3 REM TYPE REJECT
100 REM A COLLATE option must occur in a lower-numbered line than any string
110 REM expression of the same program-unit; putting it after use is rejected.
120 PRINT "EXECUTED"
130 LET A$ = "X"
140 OPTION COLLATE STANDARD
150 END
