1 REM FBCS STR-0007
2 REM CLAIM A-6.2.3-EX
3 REM TYPE SELF
100 REM Examples of 6.2.3: simple var, array element, element + substring qualifier.
110 LET FAIL = 0
120 LET K$ = "simple"
130 DIM ITEM$(3,3)
140 LET N = 2
150 LET Z = 1
160 LET ITEM$(1,N) = "ABCDE"
170 IF ITEM$(1,N)(Z:Z+2) <> "ABC" THEN LET FAIL = FAIL + 1
180 DIM A$(5)
190 LET A$(4) = "four"
200 IF A$(4) <> "four" THEN LET FAIL = FAIL + 1
210 DIM TABLES$(4,4)
220 LET TABLES$(2,2) = "cell"
230 IF TABLES$(2,2) <> "cell" THEN LET FAIL = FAIL + 1
240 DIM X$(2,3)
250 LET X$(1,3) = "element"
260 LET I = 1
270 LET J = 4
280 IF X$(1,3)(I:J) <> "elem" THEN LET FAIL = FAIL + 1
290 IF K$ <> "simple" THEN LET FAIL = FAIL + 1
300 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
310 END
