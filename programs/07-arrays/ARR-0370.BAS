1 REM FBCS ARR-0370
2 REM CLAIM A-12.1.4-TR143
3 REM TYPE OUTPUT
4 REM 12.1.4 l.8805-8807, 12.1.2 l.8708-8713, 7.1.2 l.2995-3002: the detached-handler of the main program assigns to a
5 REM numeric array and reads a string array that the main program declares with DIM.
10 DIM A(3), S$(2)
20 LET S$(1) = "HOLA"
30 WHEN EXCEPTION USE H
40   CAUSE EXCEPTION 1
50 END WHEN
60 PRINT A(2)
70 HANDLER H
80   LET A(2) = 9
90   PRINT S$(1)
100 END HANDLER
110 END
