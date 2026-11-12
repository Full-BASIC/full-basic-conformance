1 REM FBCS FIX-0172
2 REM CLAIM E-1010
3 REM TYPE OUTPUT
4 REM A size above P in a declare-statement is raised when the line executes (15.1.5 l.12288-12293; 2.4)
5 REM The declare-statement is inside the when-block, so its handler receives 1010 (12.1.4 l.8788-8797)
10 OPTION ARITHMETIC FIXED*8.2
20 PRINT "before"
30 WHEN EXCEPTION IN
40 DECLARE NUMERIC*10.10 A
50 PRINT "not reached"
60 USE
70 IF EXTYPE = 1010 THEN PRINT "caught 1010"
80 END WHEN
90 PRINT "after"
100 END
