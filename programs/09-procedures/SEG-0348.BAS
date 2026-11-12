1 REM FBCS SEG-0348
2 REM CLAIM A-9.1.2-15
3 REM TYPE REJECT
100 PRINT "EXECUTED"
110 REM The four-dimension formal array itself is rejected,
120 REM whether or not a call passes it any actual array (9.1.2 l.4256-4258)
130 FUNCTION F(A(,,,))
140 LET F = 1
150 END FUNCTION
160 END
