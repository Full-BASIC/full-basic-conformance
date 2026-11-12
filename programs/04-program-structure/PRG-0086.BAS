1 REM FBCS PRG-0086
2 REM CLAIM A-4.2.2-TR153
3 REM TYPE REJECT
4 REM 4.2.2 l.1312-1320: line numbers ascend and are unique over the whole program (else-block disorder).
100 PRINT "EXECUTED"
110 LET K = 2
120 IF K = 1 THEN
130 PRINT "T"
140 ELSE
160 PRINT "E"
150 PRINT "F"
170 END IF
180 END
