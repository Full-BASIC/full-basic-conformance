1 REM FBCS EXC-0045
2 REM CLAIM A-12.2.4-01
3 REM TYPE SELF
4 REM STD 12.2.4 l.9073-9080: each PROGRAM-UNIT has its own debugging status, inactive at the start of
5 REM the program, persisting between invocations of the unit, and not affected by the status of any
6 REM other unit. A program-unit is the main program or a procedure (4.2.2 prod. 23, l.1313); an
7 REM internal SUB is not one, it shares the status of its unit (see EXC-0102), so the units used
8 REM here are external SUBs. A BREAK is an exception only while debugging is active (l.9094-9104).
100 DECLARE EXTERNAL SUB S
110 DECLARE EXTERNAL SUB T
120 LET N = 0
130 LET M = 0
140 LET P = 0
150 CALL S(N)
160 CALL S(N)
170 CALL T(M)
180 WHEN EXCEPTION IN
190   BREAK
200 USE
210   LET P = P + 1
220 END WHEN
230 IF N = 1 AND M = 0 AND P = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; N; M; P
240 END
300 EXTERNAL SUB S(X)
310   WHEN EXCEPTION IN
320     BREAK
330   USE
340     LET X = X + 1
350   END WHEN
360   DEBUG ON
370 END SUB
400 EXTERNAL SUB T(X)
410   WHEN EXCEPTION IN
420     BREAK
430   USE
440     LET X = X + 1
450   END WHEN
460 END SUB
