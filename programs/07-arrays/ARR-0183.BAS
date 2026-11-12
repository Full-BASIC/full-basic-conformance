1 REM FBCS ARR-0183
2 REM CLAIM A-7.3.3-01
3 REM TYPE SELF
100 REM STRING MAT STATEMENTS OF THE 7.3.3 EXAMPLES (l.3380)
110 DIM A$(2), B$(2), C$(5,6), D$(4)
120 LET A$(1) = "ab"
130 LET A$(2) = "cd"
140 LET B$(1) = "x"
150 LET B$(2) = "y"
160 LET OK = 1
170 MAT A$ = A$ & B$
180 IF A$(1) <> "abx" OR A$(2) <> "cdy" THEN LET OK = 0
190 MAT C$ = NUL$(5,6)
200 IF SIZE(C$,1) <> 5 OR SIZE(C$,2) <> 6 OR LEN(C$(1,1)) <> 0 THEN LET OK = 0
210 MAT A$ = "Number" & B$
220 IF A$(1) <> "Numberx" OR A$(2) <> "Numbery" THEN LET OK = 0
230 LET D$(1) = "aaaaaa"
240 LET D$(2) = "bbbbbb"
250 LET B$(1) = "1"
260 LET B$(2) = "2"
270 MAT D$(4:6) = (" ") & B$
280 IF D$(1) <> "aaa 1" OR D$(2) <> "bbb 2" THEN LET OK = 0
290 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; D$(1); D$(2)
300 END
