1 REM FBCS FIX-0175
2 REM CLAIM E-1010
3 REM TYPE FATAL
4 REM EXPECT 1010 40
5 REM A fixed-defined-function with i+f above P loads with a warning and raises 1010 when it is invoked
6 REM (15.2.5; 9.1.4.1; 2.4)
10 OPTION ARITHMETIC FIXED*8.2
20 PRINT "before"
30 DEF F*30.10(X) = X
40 PRINT F(1)
50 PRINT "after"
60 END
