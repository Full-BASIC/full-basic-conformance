1 REM FBCS PRT-0392
2 REM CLAIM A-10.1.2-TR154
3 REM TYPE REJECT
4 REM 8.2.2 prod. 1, 10.1.2 prod. 3-4, 8.3.2 l.3792-3794: the line of an io-recovery (MAT READ) outside a
5 REM do-loop may not name a line of its do-body.
100 PRINT "EXECUTED"
110 DIM A(2)
120 LET I = 0
130 DO WHILE I < 2
140 LET I = I + 1
150 LOOP
160 MAT READ IF MISSING THEN 140: A
170 END
