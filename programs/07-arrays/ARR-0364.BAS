1 REM FBCS ARR-0364
2 REM CLAIM A-7.1.2-TR137
3 REM TYPE OUTPUT
4 REM 7.1.2 prod. 10-11 and l.2995-3002, 9.2.4.2 l.4733-4738: DECLARE NUMERIC of an array inside an internal picture
5 REM declares it for the program-unit that contains the picture; the main program uses it after the DRAW.
10 PICTURE Q
20   DECLARE NUMERIC Z(2)
30   LET Z(1) = 4
40 END PICTURE
50 DRAW Q
60 PRINT Z(1)
70 END
