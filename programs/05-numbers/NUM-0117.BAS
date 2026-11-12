1 REM FBCS NUM-0117
2 REM CLAIM A-5.3.2-01
3 REM TYPE REJECT
4 REM STD 5.3.2 l.1775-1777, 5.4.4: a supplied numeric function takes numeric arguments; a string is rejected at load.
100 PRINT "EXECUTED"
110 PRINT ABS("a")
120 END
