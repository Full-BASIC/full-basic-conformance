1 REM FBCS STR-0023
2 REM CLAIM A-6.3.4-02
3 REM TYPE SELF
100 REM String-primaries must be evaluated LEFT TO RIGHT (l.2540). Side-effect
110 REM function records the evaluation order in SEQ.
120 FUNCTION H$(N)
130   LET SEQ = SEQ * 10 + N
140   LET H$ = "x"
150 END FUNCTION
160 LET SEQ = 0
170 LET A$ = "a" & H$(1) & H$(2) & H$(3)
180 IF A$ <> "axxx" THEN PRINT "*** TEST FAILED: VALUE ***"
190 IF SEQ = 123 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED: ORDER ***"; SEQ
200 END
