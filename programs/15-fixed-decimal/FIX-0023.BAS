1 REM FBCS FIX-0023
2 REM CLAIM E-1010
3 REM TYPE FATAL
4 REM EXPECT 1010 30
5 REM 1010 of a numeric-fixed-parameter above P is raised when the function is invoked,
6 REM at the invoking line (15.2.5; 9.1.4.1; 2.4)
10 OPTION ARITHMETIC FIXED *8.2
20 DEF F(X*10.9) = X
30 PRINT F(1)
40 PRINT "EXECUTED"
50 END
