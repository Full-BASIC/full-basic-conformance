1 REM FBCS ARR-0384
2 REM CLAIM A-7.1.2-TR139
3 REM TYPE REJECT
4 REM STD 7.1.2 l.2995-3002: the main program dimensions Z and a FOR of an internal SUB
5 REM dimensions it again: rejected.
6 PRINT "EXECUTED"
10 DIM Z(3)
20 SUB S
30 FOR I = 1 TO 2
40 DIM Z(3)
50 NEXT I
60 END SUB
70 CALL S
80 END
