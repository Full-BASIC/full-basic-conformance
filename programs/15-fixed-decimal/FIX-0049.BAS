1 REM FBCS FIX-0049
2 REM CLAIM A-15.1.4-07
3 REM TYPE OUTPUT
4 REM control: FIXED*3.0 (fraction-size 0) prints " 0 " (implicit point)
5 REM STD 15.1.4 l.12250-12259 (no significant digits to the right of the point)
10 OPTION ARITHMETIC FIXED*3.0
20 LET Z = 0
30 PRINT Z
40 PRINT "<"; STR$(Z); ">"
50 PRINT USING "####": Z
60 END
