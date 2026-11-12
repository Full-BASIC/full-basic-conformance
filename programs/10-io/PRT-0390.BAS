1 REM FBCS PRT-0390
2 REM CLAIM A-10.1.2-TR154
3 REM TYPE REJECT
4 REM 8.2.2 prod. 1, 10.1.2 prod. 3-4, 8.4.2 l.3953-3958: the line of an io-recovery in a then-block may
5 REM not name a line of the sibling else-block.
100 PRINT "EXECUTED"
110 LET K = 1
120 IF K = 1 THEN
130 READ IF MISSING THEN 160: X
140 PRINT "T"
150 ELSE
160 PRINT "E"
170 END IF
180 END
