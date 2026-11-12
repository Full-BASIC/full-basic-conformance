1 REM FBCS ARR-0300
2 REM CLAIM A-7.3.4-72
3 REM TYPE SELF
4 REM Substring-qualifier on an array operand of a concatenation (7.3.4 l.3422-3424)
100 REM MAT A$ = B$(2:3) & "x", ("<") & B$(1:1) AND B$(1:1) & B$(3:3) EXTRACT THE SUBSTRING OF EVERY ELEMENT BEFORE CONCATENATING
110 OPTION BASE 1
120 DIM A$(3), B$(3)
130 LET OK = 1
140 MAT READ B$
150 DATA abc, def, ghi
160 MAT A$ = B$(2:3) & "x"
170 IF A$(1) <> "bcx" OR A$(2) <> "efx" OR A$(3) <> "hix" THEN LET OK = 0
180 MAT A$ = ("<") & B$(1:1)
190 IF A$(1) <> "<a" OR A$(2) <> "<d" OR A$(3) <> "<g" THEN LET OK = 0
200 MAT A$ = B$(1:1) & B$(3:3)
210 IF A$(1) <> "ac" OR A$(2) <> "df" OR A$(3) <> "gi" THEN LET OK = 0
220 MAT A$ = B$(2:3) & B$
230 IF A$(1) <> "bcabc" OR A$(3) <> "highi" THEN LET OK = 0
240 MAT A$ = B$ & B$(1:2)
250 IF A$(1) <> "abcab" OR A$(2) <> "defde" THEN LET OK = 0
260 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
270 END
