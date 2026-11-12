1 REM FBCS STR-0076
2 REM CLAIM A-6.4.2-TR89
3 REM TYPE REJECT
4 REM STD 6.4.2 production 3: a string-expression is not a simple-string-variable.
100 PRINT "EXECUTED"
110 LET A$ = "x"
120 PRINT MAXLEN(A$ & "y")
130 END
