1 REM FBCS ENH-0010
2 REM CLAIM A-ENH-11
3 REM TYPE SELF
4 REM External procedures keep their own line-number sequence: a unit may start
5 REM below the end-line of the main program and may repeat its line numbers,
6 REM and a GOTO reaches the line of its own unit (not conforming: 4.2.1, 4.2.2).
100 DECLARE EXTERNAL SUB S, T
105 LET FAIL = 0
110 CALL S(X)
120 IF X <> 50 THEN LET FAIL = FAIL + 1
130 CALL T(Z)
135 IF Z <> 2 THEN LET FAIL = FAIL + 1
140 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: "; FAIL
150 END
50 EXTERNAL SUB S(Y)
60 LET Y = 50
70 END SUB
120 EXTERNAL SUB T(Z)
125 GOTO 135
130 LET Z = 1
135 LET Z = 2
140 END SUB
