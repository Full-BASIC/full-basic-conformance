1 REM FBCS SEG-0542
2 REM CLAIM A-9.2.4.2-TR141
3 REM TYPE OUTPUT
4 REM 9.2.4.1 l.4660-4668, 9.2.4 l.4632-4634: a recursive internal quicksort called as QS(1, N) with the variable N.
10 DIM A(6)
20 MAT READ A
30 DATA 5, 2, 9, 1, 7, 3
40 LET G = 0
50 SUB QS(L, R)
60   LET G = G + 1
70   IF G > 50 THEN STOP
80   IF L >= R THEN EXIT SUB
90   LET P = A(R)
100   LET M = L
110   FOR J = L TO R - 1
120     IF A(J) < P THEN
130       LET T = A(J)
140       LET A(J) = A(M)
150       LET A(M) = T
160       LET M = M + 1
170     END IF
180   NEXT J
190   LET T = A(M)
200   LET A(M) = A(R)
210   LET A(R) = T
220   CALL QS(L, M - 1)
230   CALL QS(M + 1, R)
240 END SUB
250 LET N = 6
260 CALL QS(1, N)
270 PRINT A(1); A(2); A(3); A(4); A(5); A(6)
280 END
