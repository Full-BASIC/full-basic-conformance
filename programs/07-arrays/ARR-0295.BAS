1 REM FBCS ARR-0295
2 REM CLAIM A-7.3.4-71
3 REM TYPE SELF
4 REM A scalar prefix before NUL$ is prefixed to every element (7.3.2 prod. 5; 7.3.4 l.3418-3421)
100 REM MAT B$ = "b" & NUL$ GIVES EVERY ELEMENT THE PREFIX, ALSO WITH A REDIM, A VARIABLE AND THE 7.3.3 EXAMPLE
110 DIM A$(2,3), B$(2,3), C$(5), D$(3)
120 LET OK = 1
130 MAT B$ = ("b") & NUL$
140 MAT A$ = NUL$(2,3)
150 MAT A$ = A$ & B$
160 MAT A$ = ("Number") & B$
170 MAT A$(4:6) = (" ") & B$
180 IF A$(1,1) <> "Num bb" OR A$(2,3) <> "Num bb" THEN LET OK = 0
190 MAT C$ = ("c") & NUL$(3)
200 IF SIZE(C$) <> 3 OR C$(1) <> "c" OR C$(3) <> "c" THEN LET OK = 0
210 LET P$ = "pq"
220 MAT D$ = P$ & NUL$
230 IF D$(1) <> "pq" OR D$(3) <> "pq" THEN LET OK = 0
240 MAT D$ = "" & NUL$
250 IF LEN(D$(2)) <> 0 THEN LET OK = 0
260 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
270 END
