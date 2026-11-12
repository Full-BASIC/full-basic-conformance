1 REM FBCS SEG-0636
2 REM CLAIM A-4.4.2-TR165
3 REM TYPE REJECT
4 REM 4.4.2 l.1460-1466: control, a variable and an internal function of the same name are still rejected.
6 PRINT "EXECUTED"
10 DEF Q(X) = X + 1
20 LET Q = 3
30 PRINT Q
90 END
