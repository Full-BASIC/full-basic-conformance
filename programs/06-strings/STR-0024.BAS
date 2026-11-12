1 REM FBCS STR-0024
2 REM CLAIM A-6.3.4-03
3 REM TYPE SELF
100 REM Within a primary: subscripts first, then substring qualifiers, then the
110 REM value. Side-effect function records subscript evaluation order in SEQ.
120 FUNCTION G(N)
130   LET SEQ = SEQ * 10 + N
140   LET G = N
150 END FUNCTION
160 DIM X$(3,3)
170 FOR I = 1 TO 3
180   FOR J = 1 TO 3
190     LET X$(I,J) = "abcdefghi"
200   NEXT J
210 NEXT I
220 LET SEQ = 0
230 LET K = 2
240 LET L = 3
250 LET C$ = X$(G(1),G(2))(K:L)
260 LET FAIL = 0
270 IF SEQ <> 12 THEN LET FAIL = FAIL + 1
280 IF C$ <> "bc" THEN LET FAIL = FAIL + 1
290 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
300 END
