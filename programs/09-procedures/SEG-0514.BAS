1 REM FBCS SEG-0514
2 REM CLAIM A-9.2.4-TR132
3 REM TYPE OUTPUT
4 REM STD 9.2.4.1 l.4647-4651, 9.2.4.2 l.4726-4738: the argument of the EXTERNAL SUB is an expression (a temporary value);
5 REM an internal SUB assigns the parameter and the variable of the caller is not changed.
10 DECLARE EXTERNAL SUB E
20 LET Y = 1
30 CALL E(Y + 3)
40 PRINT Y
50 END
100 EXTERNAL SUB E(N)
110 SUB S
120   LET N = N + 40
130 END SUB
140 CALL S
150 PRINT N
160 END SUB
