1 REM FBCS SEG-0678
2 REM CLAIM A-9.1.2-20
3 REM TYPE REJECT
4 REM 9.1.2 l.4271-4274: of two functions declared together only one is defined in the unit, the other is never called.
100 PRINT "EXECUTED"
110 DECLARE FUNCTION F, H
120 FUNCTION F(X)
130 LET F = X
140 END FUNCTION
150 END
