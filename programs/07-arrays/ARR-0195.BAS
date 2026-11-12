1 REM FBCS ARR-0195
2 REM CLAIM E-1106
3 REM TYPE SELF
4 REM MAT F$ = E$ & E$ builds 8-character elements for an array whose length-max is 4. The assignment
5 REM of a value to a string-array that overflows is exception 1106 (7.3.5 l.3468). The evaluation
6 REM overflow 1052 (l.3465) is not used: the maximum string length is MAXNUM (D-6.2-1), see interpretations.yaml.
100 DECLARE STRING E$(2)*4, F$(2)*4
110 LET E$(1) = "abcd"
120 LET E$(2) = "efgh"
130 WHEN EXCEPTION IN
140   MAT F$ = E$ & E$
150   PRINT "*** TEST FAILED: NO EXCEPTION ***"
160 USE
170   IF EXTYPE = 1106 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: EXTYPE"; EXTYPE
180 END WHEN
190 END
