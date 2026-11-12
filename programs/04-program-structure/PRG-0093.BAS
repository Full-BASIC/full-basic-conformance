1 REM FBCS PRG-0093
2 REM CLAIM A-4.2.2-TR153
3 REM TYPE REJECT
4 REM 4.2.2 l.1312-1320: line numbers ascend and are unique over the whole program (duplicate in a then-block).
100 PRINT "EXECUTED"
110 LET K = 1
120 IF K = 1 THEN
130 PRINT "A"
130 PRINT "B"
140 END IF
150 END
