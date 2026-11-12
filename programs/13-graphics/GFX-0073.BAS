1 REM FBCS GFX-0073
2 REM CLAIM A-13.5.2-05
3 REM TYPE REJECT
4 REM P is declared twice and then defined once; the definition makes the declaration legitimate, so
5 REM the only rule left to break is the second DECLARE (13.5.2 l.10511-10512, read as: one picture per name).
100 PRINT "EXECUTED"
110 DECLARE PICTURE P
120 DECLARE PICTURE P
130 STOP
200 PICTURE P
210 END PICTURE
999 END
