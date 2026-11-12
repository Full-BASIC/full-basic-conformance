1 REM FBCS FIL-0389
2 REM CLAIM A-11.5.4.3-TR110
3 REM TYPE SELF
4 REM STD 11.5.4.3 l.8571-8573 (the delete-statement deletes the record indicated by the file
5 REM pointer and advances the pointer to the next file-element; in a RELATIVE file the
6 REM file-elements are the record-areas). After deleting area 1 the pointer is at area 2.
10 LET OK = 1
100 OPEN #1: NAME "FIL0389.DAT", ACCESS OUTIN, ORGANIZATION RELATIVE, RECTYPE INTERNAL
110 ERASE #1
120 WRITE #1: 10
130 WRITE #1: 20
140 WRITE #1: 30
150 DELETE #1, RECORD 1
160 ASK #1: RECORD R
170 READ #1: X
180 IF R <> 2 OR X <> 20 THEN LET OK = 0
190 IF R <> 2 OR X <> 20 THEN PRINT "FALLO-DELETE-RECORD "; R; X
200 SET #1: RECORD 2
210 DELETE #1
220 READ #1: Y
230 IF Y <> 30 THEN LET OK = 0
240 IF Y <> 30 THEN PRINT "FALLO-DELETE-SET "; Y
250 CLOSE #1
900 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
910 END
