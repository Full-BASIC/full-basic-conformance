1 REM FBCS SEG-0541
2 REM CLAIM A-9.2.4.2-TR141
3 REM TYPE OUTPUT
4 REM 9.2.4.2 l.4718-4721, 9.2.4.1 l.4649-4653: only the outermost invocation of a recursive internal SUB is bound by
5 REM reference to the variable K; its assignment to the parameter reaches K and the nested calls do not touch K.
20 SUB S(I)
30   LET G = G + 1
40   IF G > 9 THEN STOP
50   IF I < 3 THEN CALL S(I + 1)
60   LET I = I + 100
70 END SUB
85 LET G = 0
90 LET K = 1
100 CALL S(K)
105 PRINT K
110 END
