1 REM FBCS STR-0049
2 REM CLAIM A-6.6.2-03
3 REM TYPE REJECT
100 REM No simple-string-variable shall be declared more than once in a
110 REM program-unit; a duplicate declaration must be rejected.
120 PRINT "EXECUTED"
130 DECLARE STRING A$ * 3
140 DECLARE STRING A$ * 4
150 END
