1 REM FBCS FIL-0218
2 REM CLAIM A-11.3.2-09
3 REM TYPE REJECT
4 REM STD 11.3.2 l.7468-7469: the record-setter in a write-control (here of an
5 REM array-write-statement, KEY >=) shall not specify an inexact-search; rejected at load.
100 PRINT "EXECUTED"
110 DIM A(2)
120 OPEN #1: NAME "FIL0218.DAT", ACCESS OUTIN, ORGANIZATION KEYED, RECTYPE INTERNAL
130 MAT WRITE #1, KEY >= "A": A
140 END
