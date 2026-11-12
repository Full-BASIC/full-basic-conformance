1 REM FBCS STR-0043
2 REM CLAIM A-6.5.4-01
3 REM TYPE SELF
100 REM In a string LET: target qualifiers left to right, then the RHS
110 REM expression, then the stores left to right (l.2800-2804).
120 FUNCTION G(N)
130   LET SEQ = SEQ * 10 + N
140   LET G = N
150 END FUNCTION
160 FUNCTION H$(N)
170   LET SEQ = SEQ * 10 + N
180   LET H$ = "x"
190 END FUNCTION
200 LET FAIL = 0
210 DIM E$(10), F$(10)
220 LET SEQ = 0
230 LET E$(G(3)), F$(G(4)) = H$(5)
240 IF SEQ <> 345 THEN LET FAIL = FAIL + 1
250 IF E$(3) <> "x" THEN LET FAIL = FAIL + 1
260 IF F$(4) <> "x" THEN LET FAIL = FAIL + 1
270 REM Store order left to right: LET A$(1:2), A$(2:3) = "X" on "abcd"
280 REM gives "XX" (l.2803-2804, 6.5.6 remark).
290 LET B$ = "abcd"
300 LET B$(1:2), B$(2:3) = "X"
310 IF B$ <> "XX" THEN LET FAIL = FAIL + 1
320 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
330 END
