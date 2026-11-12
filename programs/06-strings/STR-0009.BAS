1 REM FBCS STR-0009
2 REM CLAIM A-6.2.4-02
3 REM TYPE SELF
100 REM Subscripts of a string-array element inside the declared bounds are OK.
110 LET FAIL = 0
120 DIM A$(2,3)
130 FOR I = 1 TO 2
140   FOR J = 1 TO 3
150     LET A$(I,J) = "x"
160     IF A$(I,J) <> "x" THEN LET FAIL = FAIL + 1
170   NEXT J
180 NEXT I
190 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
200 END
