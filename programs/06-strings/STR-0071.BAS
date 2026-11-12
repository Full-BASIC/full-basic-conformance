1 REM FBCS STR-0071
2 REM CLAIM A-6.3.2-01
3 REM TYPE REJECT
4 REM STD 6.3.2 l.2514-2516, 6.4.4 (LEN(A$)): a string function takes a string-expression; a number is rejected at load.
100 PRINT "EXECUTED"
110 PRINT LEN(1)
120 END
