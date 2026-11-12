1 REM FBCS PRG-0054
2 REM CLAIM A-4.4.4-01
3 REM TYPE SELF
4 REM An INTERNAL subprogram belongs to its containing program-unit: its variables are
5 REM the unit's own (global to it) and keep their values between calls (9.2.4.2 l.4733-4737).
10 SUB S
20 LET C = C + 1
30 END SUB
40 LET C = 10
50 CALL S
60 CALL S
70 IF C = 12 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; C
80 END
