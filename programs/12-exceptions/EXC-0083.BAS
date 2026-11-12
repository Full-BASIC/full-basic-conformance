1 REM FBCS EXC-0083
2 REM CLAIM A-12.1.4-09
3 REM TYPE SELF
10 REM STD 12.1.4 l.8873-8875, l.8877-8899: an exception raised
20 REM inside the handler of a routine is taken by the default
30 REM procedure, which (being fatal and outside every when-block of the
40 REM routine) propagates it to the invoking line: the handler of the caller
50 REM receives it with EXTYPE = 100009 and EXLINE = 90 (the CALL).
60 DECLARE EXTERNAL SUB S
70 LET OK = 0
75 LET V = 0
80 WHEN EXCEPTION IN
90   CALL S
100  PRINT "*** TEST FAILED *** (no excepcion)"
110 USE
120  LET V = EXTYPE
125  IF EXTYPE = 100009 AND EXLINE = 90 THEN LET OK = 1
130 END WHEN
140 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; V
150 END
160 EXTERNAL SUB S
170 WHEN EXCEPTION IN
180   CAUSE EXCEPTION 7
190 USE
200   CAUSE EXCEPTION 9
210 END WHEN
220 PRINT "*** TEST FAILED *** (siguio en la rutina)"
230 END SUB
