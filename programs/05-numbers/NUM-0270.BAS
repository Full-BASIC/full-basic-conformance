1 REM FBCS NUM-0270
2 REM CLAIM A-5.6.2-TR173
3 REM TYPE REJECT
4 REM STD 5.6.2 l.2216-2218: an OPTION ANGLE after a reference to ABS, a numeric-supplied-function other than a trigonometric one.
10 PRINT "EXECUTED"
20 LET X = ABS(-1)
30 OPTION ANGLE DEGREES
40 PRINT SIN(30)
50 END
