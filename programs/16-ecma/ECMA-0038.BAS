1 REM FBCS ECMA-0038
2 REM CLAIM A-ECMA-21
3 REM TYPE SELF
100 LET A$ = "7x"
110 LET M$ = "m"
120 SELECT CASE A$(1:1)
130 CASE "A" TO "Z", "a" TO "z"
140 PRINT A$; "starts with a letter"
150 CASE "0" TO "9"
160 PRINT A$; "starts with a digit"
170 CASE ELSE
180 PRINT A$; "doesn""t start with a letter or a digit"
190 END SELECT
200 IF A$(1:1) = "7" THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
210 END
