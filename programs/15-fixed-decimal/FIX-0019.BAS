1 REM FBCS FIX-0019
2 REM CLAIM A-15.1.4-06
3 REM TYPE OUTPUT
4 REM STD 15.1.4 l.12281-12285: for numeric data in a STREAM INTERNAL file written
5 REM under FIXED, DATUM is NUMERIC*ii.ff with the integer-size and fraction-size
6 REM of the datum itself; l.12264-12267 (self-typed): a DECLARE NUMERIC*3.1
7 REM variable keeps its own 03.01 in the file. STD 11.4.4 l.8056-8057: after a
8 REM partial READ of a multi-datum WRITE the pointer is at the next pending
9 REM value, and DATUM reports its type.
10 OPTION ARITHMETIC FIXED *8.2
20 DECLARE NUMERIC*3.1 B
30 LET B = 2
40 OPEN #1: NAME "fix0019.dat", ACCESS OUTIN, ORGANIZATION STREAM, RECTYPE INTERNAL
50 WRITE #1: 123.45, "hello", B
60 SET #1: POINTER BEGIN
70 ASK #1: DATUM N$
80 PRINT "["; N$; "]"
90 READ #1: NUM
100 ASK #1: DATUM S$
110 PRINT "["; S$; "]"
120 READ #1: V$
130 ASK #1: DATUM F$
140 PRINT "["; F$; "]"
150 READ #1: W
160 ASK #1: DATUM E$
170 PRINT "["; E$; "]"
180 ERASE #1
190 CLOSE #1
200 END
