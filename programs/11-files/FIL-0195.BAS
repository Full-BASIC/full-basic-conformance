1 REM FBCS FIL-0195
2 REM CLAIM A-11.1.4.9-05
3 REM TYPE OUTPUT
4 REM STD 11.1.4.9 Tabla 5 l.6964-6973: DATUM = type of the next datum following
5 REM the current pointer position (NUMERIC/STRING/NONE), well-defined for
6 REM STREAM INTERNAL files. STD 11.4.4 l.8056-8057: after a successful READ the
7 REM pointer advances to the next file element, i.e. the next VALUE in a STREAM
8 REM file (l.8061-8062 case 2), so after a partial READ of a multi-datum WRITE
9 REM the pending value is the next datum. SET #n: POINTER BEGIN/END moves it.
10 OPEN #1: NAME "FIL0195.DAT", ACCESS OUTIN, ORGANIZATION STREAM, RECTYPE INTERNAL
20 WRITE #1: 1, "S", 2
30 SET #1: POINTER BEGIN
40 ASK #1: DATUM D1$
50 READ #1: X
60 ASK #1: DATUM D2$
70 READ #1: S$
80 ASK #1: DATUM D3$
90 READ #1: Y
100 ASK #1: DATUM D4$
110 SET #1: POINTER BEGIN
120 ASK #1: DATUM D5$
130 SET #1: POINTER END
140 ASK #1: DATUM D6$
150 PRINT D1$; " "; D2$; " "; D3$; " "; D4$; " "; D5$; " "; D6$
160 PRINT X; S$; Y
170 CLOSE #1
180 END
