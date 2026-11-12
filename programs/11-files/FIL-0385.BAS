1 REM FBCS FIL-0385
2 REM CLAIM A-11.2.4.1-TR105
3 REM TYPE SELF
4 REM STD 11.2.4.1 l.7234-7240 (if the most recent operation was a READ, SAME resets the pointer
5 REM to the same file element it was just set to by the record-setter of that operation; with no
6 REM record-setter, to the location it had at the beginning of that operation). On a STREAM file
7 REM the file elements are individual values, so after READ A, READ B the pointer returns to B.
10 LET OK = 1
100 OPEN #1: NAME "FIL0385.DAT", ACCESS OUTIN, ORGANIZATION STREAM, RECTYPE INTERNAL
110 ERASE #1
120 WRITE #1: 1, 2, 3
130 SET #1: POINTER BEGIN
140 READ #1: A
150 READ #1: B
160 SET #1: POINTER SAME
170 READ #1: C
180 IF A <> 1 OR B <> 2 OR C <> 2 THEN LET OK = 0
190 IF C <> 2 THEN PRINT "FALLO-SAME-2 "; A; B; C
200 SET #1: POINTER BEGIN
210 READ #1: A
220 READ #1: B
230 READ #1: C
240 SET #1: POINTER SAME
250 READ #1: D
260 IF D <> 3 THEN LET OK = 0
270 IF D <> 3 THEN PRINT "FALLO-SAME-3 "; A; B; C; D
280 READ #1, SAME: E
290 IF E <> 3 THEN LET OK = 0
300 IF E <> 3 THEN PRINT "FALLO-READ-SAME "; E
310 CLOSE #1
900 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
910 END
