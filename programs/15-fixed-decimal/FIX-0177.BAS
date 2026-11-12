1 REM FBCS FIX-0177
2 REM CLAIM E-1010
3 REM TYPE OUTPUT
4 REM 1010 of a numeric-fixed-parameter above P is raised at the CALL line; the enclosing when-block gets
5 REM EXTYPE 1010 (not 101010: not a line of the procedure-part, 12.1.4 l.8879-8905) and EXLINE = the call line
10 OPTION ARITHMETIC FIXED*8.2
20 WHEN EXCEPTION IN
30 CALL S(1)
40 PRINT "not reached"
50 USE
60 IF EXTYPE = 1010 AND EXLINE = 30 THEN PRINT "1010 at line 30" ELSE PRINT "wrong"
70 END WHEN
80 PRINT "after"
90 STOP
100 SUB S(X*30.10)
110 PRINT X
120 END SUB
130 END
