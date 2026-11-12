1 REM FBCS SEG-0250
2 REM CLAIM A-9.2.2-06
3 REM TYPE SELF
4 REM CALL of an internal SUB whose definition follows it, with no DECLARE SUB. The text
5 REM requires the order (9.2.2 l.4528-4532) but 9.2.6 l.4771-4774 lets an implementation
6 REM relax it for internal subprograms; this interpreter does, so the program runs.
100 CALL S
110 SUB S
120 PRINT "*** TEST PASSED ***"
130 END SUB
140 END
