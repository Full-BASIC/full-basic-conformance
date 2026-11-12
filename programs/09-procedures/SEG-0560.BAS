1 REM FBCS SEG-0560
2 REM CLAIM A-9.2.4.1-TR142
3 REM TYPE OUTPUT
4 REM 9.2.4.1 l.4649-4655, l.4660-4668: a variable argument before an argument that calls a user function stays bound by reference.
10 DECLARE EXTERNAL SUB U
20 DEF F(X) = X * 2
30 LET I = 3
40 CALL U(I, F(4))
50 PRINT I
60 END
300 EXTERNAL SUB U(K, H)
310 PRINT K; H
320 LET K = K + 10
330 END SUB
