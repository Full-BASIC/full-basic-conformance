1 REM FBCS SEG-0525
2 REM CLAIM A-9.1.2-TR137
3 REM TYPE OUTPUT
4 REM 9.1.2 l.4201-4205, 13.5.2 l.10514-10518: an internal PICTURE of the main program declares the external FUNCTION
5 REM it uses; the declare-statement counts for the program-unit that contains the picture.
10 PICTURE Q
20   DECLARE EXTERNAL FUNCTION F
30   PRINT F
40 END PICTURE
50 DRAW Q
60 END
200 EXTERNAL FUNCTION F
210 LET F = 2
220 END FUNCTION
