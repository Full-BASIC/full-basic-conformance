1 REM FBCS SEG-0540
2 REM CLAIM A-9.2.4.2-TR141
3 REM TYPE OUTPUT
4 REM 9.2.4.2 l.4718-4721, 9.2.4.1 l.4660-4668, 9.2.4 l.4632-4634: a recursive internal SUB first called with a variable; the nested
5 REM calls pass an expression, so each invocation has its own local parameter.
20 SUB S(I)
30   LET G = G + 1
40   IF G > 9 THEN STOP
50   PRINT "IN"; I
60   IF I < 3 THEN CALL S(I + 1)
70   PRINT "OUT"; I
80 END SUB
85 LET G = 0
90 LET K = 1
100 CALL S(K)
110 END
