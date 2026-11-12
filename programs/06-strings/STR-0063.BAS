1 REM FBCS STR-0063
2 REM CLAIM A-6.2.4-06
3 REM TYPE SELF
100 REM Substring-qualifier indices are indices (STD 6.2.4 l.2449-2452: "M and N
110 REM are indices"); an index is rounded to INT(X+.5) (STD 5.2.4 l.1700-1702).
120 REM With A$ = "ABCDEFG": A$(1.6:3.4) = A$(2:3) = "BC", A$(2.4:4.6) = A$(2:5)
130 REM = "BCDE", A$(1.5:1.5) = A$(2:2) = "B", A$(3:3.6) = A$(3:4) = "CD".
140 LET FAIL = 0
150 LET A$ = "ABCDEFG"
160 IF A$(1.6:3.4) <> "BC" THEN LET FAIL = FAIL + 1
170 IF A$(2.4:4.6) <> "BCDE" THEN LET FAIL = FAIL + 1
180 IF A$(1.5:1.5) <> "B" THEN LET FAIL = FAIL + 1
190 IF A$(3:3.6) <> "CD" THEN LET FAIL = FAIL + 1
200 DIM B$(2)
210 LET B$(1) = "ABCDEFG"
220 LET B$(2) = "XY"
230 IF B$(1)(1.6:3.4) <> "BC" THEN LET FAIL = FAIL + 1
240 IF B$(2)(2.4:1.6) <> "Y" THEN LET FAIL = FAIL + 1
250 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
260 END
