1 REM FBCS PRT-0394
2 REM CLAIM A-10.1.2-TR154
3 REM TYPE REJECT
4 REM 8.2.2 prod. 1, 10.1.2 prod. 3-4, 9.2.2 l.4511-4512: the line of an io-recovery in an external
5 REM subprogram may not name the header line of the subprogram.
100 PRINT "EXECUTED"
110 DECLARE EXTERNAL SUB E
120 CALL E
130 END
140 EXTERNAL SUB E
150 READ IF MISSING THEN 140: X
160 END SUB
