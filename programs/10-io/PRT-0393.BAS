1 REM FBCS PRT-0393
2 REM CLAIM A-10.1.2-TR154
3 REM TYPE REJECT
4 REM 8.2.2 prod. 1, 10.1.2 prod. 3-4, 12.1.2 l.8697-8698: the line of an io-recovery outside a
5 REM protection-block may name only its when-line, not a line inside it.
100 PRINT "EXECUTED"
110 READ IF MISSING THEN 140: X
120 WHEN EXCEPTION IN
130 PRINT "W"
140 PRINT "W2"
150 USE
160 PRINT "H"
170 END WHEN
180 END
