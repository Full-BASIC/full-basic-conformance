1 REM FBCS FIL-0216
2 REM CLAIM A-11.3.4-03
3 REM TYPE SELF
4 REM STD 11.3.4 l.7536-7541: in a KEYED file, WRITE #1, KEY k leaves the pointer
5 REM at the next file-element beyond the one created (the next key in the key
6 REM sequence, or end of file). STD 11.1.4.9 Tabla 5 l.6987-6992: ASK KEY gives
7 REM the key of the record identified by the pointer, null at end of file.
10 LET OK = 1
20 OPEN #1: NAME "FIL0216.DAT", ACCESS OUTIN, ORGANIZATION KEYED, RECTYPE INTERNAL
30 WRITE #1, KEY "A": 1
40 WRITE #1, KEY "C": 3
50 WRITE #1, KEY "B": 2
60 ASK #1: KEY K$
70 IF K$ <> "C" THEN LET OK = 0
80 IF K$ <> "C" THEN PRINT "FALLO-KEY"; K$
90 READ #1: X
100 IF X <> 3 THEN LET OK = 0
110 IF X <> 3 THEN PRINT "FALLO-READ"; X
120 REM the last key: the pointer is left at end of file
130 WRITE #1, KEY "D": 4
140 ASK #1: KEY K2$, POINTER P$
150 IF K2$ <> "" OR P$ <> "END" THEN LET OK = 0
160 IF K2$ <> "" OR P$ <> "END" THEN PRINT "FALLO-EOF"; K2$; P$
170 READ #1, IF MISSING THEN 200: Y
180 LET OK = 0
190 PRINT "FALLO-READ-EOF"; Y
200 CLOSE #1
210 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
220 END
