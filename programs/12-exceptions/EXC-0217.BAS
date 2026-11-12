1 REM FBCS EXC-0217
2 REM CLAIM A-12.2.4-TR136
3 REM TYPE SELF
4 REM 12.2.4 l.9128-9143 (point 2, subscripts of an array element), D-12.2-2: the trace reports the assignment to an element
5 REM of a formal-array of an internal SUB with the name of the formal-array, the subscript and the value.
10 OPEN #3: NAME "EXC0217.TXT", ACCESS OUTPUT
20 DEBUG ON
30 TRACE ON TO #3
35 DIM W(3)
40 SUB S(V())
50   LET V(2) = 7
60 END SUB
70 CALL S(W)
90 TRACE OFF
95 CLOSE #3
300 OPEN #3: NAME "EXC0217.TXT", ACCESS INPUT
310 LET FOUND = 0
320 FOR K = 1 TO 40
330   LINE INPUT #3, IF MISSING THEN EXIT FOR: L$
340   IF POS(L$, "V(2)=7") > 0 THEN LET FOUND = 1
350 NEXT K
360 CLOSE #3
370 IF FOUND = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
400 END
