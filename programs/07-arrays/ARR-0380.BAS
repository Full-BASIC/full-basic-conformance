1 REM FBCS ARR-0380
2 REM CLAIM A-7.1.2-TR139
3 REM TYPE OUTPUT
4 REM STD 7.1.4 l.3056-3058, 7.1.2 l.2995-3002: a DIM in an IF that is not taken, in an
5 REM internal SUB that is never called, still declares the array of the main program.
10 SUB S
20 IF 1 = 0 THEN
30 DIM Z(3)
40 END IF
50 END SUB
60 LET Z(2) = 4
70 PRINT Z(2)
80 END
