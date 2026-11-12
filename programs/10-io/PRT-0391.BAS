1 REM FBCS PRT-0391
2 REM CLAIM A-10.1.2-TR154
3 REM TYPE REJECT
4 REM 8.2.2 prod. 1, 10.1.2 prod. 3-4, 8.3.2 l.3792-3794: the line of an io-recovery outside a for-loop
5 REM may not name a line of its for-body.
100 PRINT "EXECUTED"
110 FOR I = 1 TO 2
120 PRINT I
130 NEXT I
140 READ IF MISSING THEN 120: X
150 END
