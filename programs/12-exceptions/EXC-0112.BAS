1 REM FBCS EXC-0112
2 REM CLAIM A-12.1.2-TR94
3 REM TYPE REJECT
4 REM STD 12.1.2 l.8691-8692: EXTEXT$ takes a numeric argument; a string argument is rejected at load.
100 PRINT "EXECUTED"
110 PRINT EXTEXT$("a")
120 END
