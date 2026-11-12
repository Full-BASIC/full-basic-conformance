1 REM FBCS NUM-0277
2 REM CLAIM A-5.6.2-TR173
3 REM TYPE OUTPUT
4 REM STD 5.6.2 l.2216-2218: an OPTION ANGLE before any function reference is accepted, and the later functions use it.
10 OPTION ANGLE DEGREES
20 LET X = ABS(-2) + INT(2.5) + LEN("AB")
30 PRINT X; SIN(30)
40 END
