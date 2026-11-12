1 REM FBCS STR-0020
2 REM CLAIM A-6.3.2-03
3 REM TYPE SELF
100 REM Declared (DECLARE DEF) in a lower-numbered line, defined later: OK.
110 DECLARE DEF F$
120 LET X$ = F$("ok")
130 DEF F$(A$) = A$ & "!"
140 IF X$ <> "ok!" THEN PRINT "*** TEST FAILED ***" ELSE PRINT "*** TEST PASSED ***"
150 END
