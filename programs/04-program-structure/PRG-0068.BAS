1 REM FBCS PRG-0068
2 REM CLAIM A-4.4.4-09
3 REM TYPE REJECT
100 REM Within the scope of LET SIN, the supplied function SIN "shall be unavailable"
110 REM (4.4.4 l.1511-1518), so SIN(0) is not a function call here
120 LET SIN = 1
130 PRINT SIN(0)
140 PRINT "EXECUTED"
150 END
