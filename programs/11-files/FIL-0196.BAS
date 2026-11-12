1 REM FBCS FIL-0196
2 REM CLAIM A-11.3.4-01
3 REM TYPE OUTPUT
4 REM STD 11.4.4 l.8056-8057: after READ the pointer is at the next VALUE of a STREAM file,
5 REM so after a partial READ of WRITE 1,"S",2 it identifies "S", an existing element.
6 REM STD 11.2.4.1 l.7192-7194: absent record-setter leaves the pointer unchanged.
7 REM STD 11.2.4.2 l.7270-7291 + 11.3.5.2 l.7904-7908: data-found true and no
8 REM not-missing-recovery -> fatal 7308, pointer and file unchanged (no 9 at the end).
10 OPEN #1: NAME "FIL0196.DAT", ACCESS OUTIN, ORGANIZATION STREAM, RECTYPE INTERNAL
20 WRITE #1: 1, "S", 2
30 SET #1: POINTER BEGIN
40 READ #1: X
50 WHEN EXCEPTION IN
60 WRITE #1: 9
70 PRINT "WRITE-OK"
80 USE
90 PRINT "EXTYPE="; EXTYPE
100 END WHEN
110 ASK #1: DATUM D1$
120 READ #1: S$
130 READ #1: Y
140 ASK #1: DATUM D2$
150 PRINT X; "|"; S$; "|"; Y; "|"; D1$; "|"; D2$
160 SET #1: POINTER END
170 WRITE #1: 9
180 SET #1: POINTER BEGIN
190 READ #1: A, B$, C, D
200 PRINT A; "|"; B$; "|"; C; "|"; D
210 CLOSE #1
220 END
