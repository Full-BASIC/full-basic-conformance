1 REM FBCS STR-0064
2 REM CLAIM A-6.5.4-03
3 REM TYPE SELF
100 REM Assigning to a substring-qualified target with non-integer indices rounds
110 REM them first (STD 6.5.4 l.2808-2811 with 6.2.4 l.2449-2452 and 5.2.4
120 REM l.1700-1702: index = INT(X+.5)). With A$ = "ABCDEFG", LET A$(1.6:2.4)
130 REM = "xy" replaces A$(2:2), giving "AxyCDEFG".
140 LET FAIL = 0
150 LET A$ = "ABCDEFG"
160 LET A$(1.6:2.4) = "xy"
170 IF A$ <> "AxyCDEFG" THEN LET FAIL = FAIL + 1
180 IF A$(2:2) <> "x" THEN LET FAIL = FAIL + 1
190 DIM B$(2)
200 LET B$(1) = "ABCDEFG"
210 LET B$(2) = "XY"
220 LET B$(1)(1.6:2.4) = "xy"
230 IF B$(1) <> "AxyCDEFG" THEN LET FAIL = FAIL + 1
240 LET C$ = "ABCDEFG"
250 LET D$ = "XYZW"
260 LET C$(1.6:2.4), D$(2.6:3.4) = "z"
270 IF C$ <> "AzCDEFG" THEN LET FAIL = FAIL + 1
280 IF D$ <> "XYzW" THEN LET FAIL = FAIL + 1
290 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
300 END
