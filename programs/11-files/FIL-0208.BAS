1 REM FBCS FIL-0208
2 REM CLAIM A-11.1.4.9-TR48KEY
3 REM TYPE OUTPUT
4 REM STD 11.1.4.9 Tabla 5 l.6987-6991: "KEY A$ - ... If the pointer is at the
5 REM end of file or if this is not a keyed file, the null string is assigned."
6 REM 11.2.4.1 l.7263-7266: an inexact greater-than search with no greater key sets
7 REM the pointer to end of file, so ASK KEY after SET #1: KEY > "C" (keys A, C)
8 REM assigns the null string. Controls: POINTER END also gives null; an exact
9 REM search on an existing record gives its key.
10 OPEN #1: NAME "FIL0208.DAT", ACCESS OUTIN, ORGANIZATION KEYED, RECTYPE INTERNAL
20 WRITE #1, KEY "A": 1
30 WRITE #1, KEY "C": 3
40 SET #1: KEY > "C"
50 ASK #1: KEY K$, POINTER P$
60 PRINT "<"; K$; ">"; P$
70 SET #1: POINTER END
80 ASK #1: KEY K2$
90 PRINT "<"; K2$; ">"
100 SET #1: KEY "A"
110 ASK #1: KEY K3$, POINTER P3$
120 PRINT "<"; K3$; ">"; P3$
130 CLOSE #1
140 END
