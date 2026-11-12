1 REM FBCS CTL-0010
2 REM CLAIM A-8.1.4-03
3 REM TYPE SELF
100 REM String ordering per collating sequence (Table 8) (l.3549-3561)
110 LET OK = 1
120 IF NOT ("ABC" < "ABD") THEN LET OK = 0
130 IF "ABD" < "ABC" THEN LET OK = 0
140 IF NOT ("AB" < "ABC") THEN LET OK = 0
150 IF "ABC" < "AB" THEN LET OK = 0
160 IF NOT ("" < "A") THEN LET OK = 0
170 IF "A" < "" THEN LET OK = 0
180 REM unequal lengths, not a prefix: shorter vs leftmost part of longer
190 IF "C" < "AB" THEN LET OK = 0
200 IF NOT ("AB" < "C") THEN LET OK = 0
210 IF NOT ("AB1" < "ABC") THEN LET OK = 0
220 IF NOT ("9" < "A") THEN LET OK = 0
230 IF NOT ("Z" < "a") THEN LET OK = 0
240 IF NOT ("abc" < "abd") THEN LET OK = 0
250 REM derived relations
260 IF NOT ("AB" <= "ABC") THEN LET OK = 0
270 IF NOT ("ABC" >= "AB") THEN LET OK = 0
280 IF NOT ("A" <> "B") THEN LET OK = 0
290 IF "A" <> "A" THEN LET OK = 0
300 IF NOT ("B" > "A") THEN LET OK = 0
310 IF "A" > "B" THEN LET OK = 0
320 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
330 END
