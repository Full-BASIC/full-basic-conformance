1 REM FBCS PRG-0091
2 REM CLAIM A-4.2.2-TR153
3 REM TYPE REJECT
4 REM 4.2.2 l.1312-1320: line numbers ascend and are unique over the whole program (internal sub nested in an if disorder).
100 PRINT "EXECUTED"
110 SUB S
120 LET K = 1
130 IF K = 1 THEN
150 PRINT "A"
140 PRINT "B"
160 END IF
170 END SUB
180 CALL S
190 END
