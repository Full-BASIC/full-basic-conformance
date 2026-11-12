1 REM FBCS EXC-0077
2 REM CLAIM A-12.1.6-01
3 REM TYPE SELF
10 REM STD 12.1.6 l.8970-8972: a nonfatal exception inside an
20 REM external sub called from a when-block is NOT passed to the handler
30 REM of the caller; the system handler takes it and the sub goes on.
40 DECLARE EXTERNAL SUB S
50 LET CAUGHT = 0
60 WHEN EXCEPTION IN
70   CALL S
80 USE
90   LET CAUGHT = 1
100   PRINT "*** TEST FAILED ***"; EXTYPE; EXLINE
110 END WHEN
120 IF CAUGHT = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
130 END
140 EXTERNAL SUB S
150 CLOSE #0
160 PRINT "SIGUE"
170 END SUB
