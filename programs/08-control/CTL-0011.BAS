1 REM FBCS CTL-0011
2 REM CLAIM A-8.1.4-04
3 REM TYPE SELF
100 REM Precedence NOT > AND > OR as implied by the grammar (l.3565)
110 LET OK = 1
120 REM NOT applies only to the relational-primary after it
130 IF NOT 1 < 2 THEN LET OK = 0
140 IF NOT (NOT 1 = 2) THEN LET OK = 0
150 IF NOT (NOT 1 = 2 AND 1 = 1) THEN LET OK = 0
160 REM AND binds tighter than OR
170 IF NOT (1 = 1 OR 1 = 2 AND 1 = 2) THEN LET OK = 0
180 IF NOT (1 = 2 OR 2 = 2 AND 3 = 3) THEN LET OK = 0
190 IF 1 = 2 OR 1 = 2 AND 1 = 1 THEN LET OK = 0
200 IF NOT (1 = 1 AND 2 = 2 AND 3 = 3) THEN LET OK = 0
210 IF NOT ((1 = 1)) THEN LET OK = 0
220 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
230 END
