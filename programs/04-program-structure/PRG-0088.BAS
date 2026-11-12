1 REM FBCS PRG-0088
2 REM CLAIM A-4.2.2-TR153
3 REM TYPE REJECT
4 REM 4.2.2 l.1312-1320: line numbers ascend and are unique over the whole program (do body disorder).
100 PRINT "EXECUTED"
110 LET K = 0
120 DO WHILE K < 2
140 LET K = K + 1
130 PRINT K
150 LOOP
160 END
