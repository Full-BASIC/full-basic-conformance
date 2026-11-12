1 REM FBCS FIX-0176
2 REM CLAIM E-1010
3 REM TYPE OUTPUT
4 REM Definitions with a fixed-point-size above P that are never invoked raise nothing (2.4)
5 REM Sum equal to P (9+9) is legal and works when invoked (15.1.5)
10 OPTION ARITHMETIC FIXED*8.2
20 DEF F*30.10(X) = X
30 DEF G(X*10.10) = X
40 FUNCTION H*30.10(X)
50 LET H = X
60 END FUNCTION
70 SUB S(X*30.10)
80 PRINT X
90 END SUB
100 DEF K(X*9.9) = X
110 PRINT "never invoked"
120 PRINT K(1)
130 END
