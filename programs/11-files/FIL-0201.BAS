1 REM FBCS FIL-0201
2 REM CLAIM A-11.2.4.2-07
3 REM TYPE OUTPUT
4 REM STD 11.2.2 l.7149-7150: pointer-items = pointer-control / io-recovery /
5 REM pointer-control comma io-recovery (io-recovery WITHOUT pointer-control is valid).
6 REM STD 11.2.4 l.7181-7184: after the set-statement with pointer-items, the
7 REM optional io-recovery acts on data-found. STD 11.2.4.1 l.7196-7198:
8 REM without a record-setter the pointer does not change and the io-recovery still acts.
9 REM STD 11.2.4.2 l.7270-7296: data-found is false at end of file (l.7284);
10 REM the io-recovery-action (a line or EXIT FOR) is taken (l.7293-7296).
100 OPEN #1: NAME "FIL0201.DAT", ACCESS OUTIN, ORGANIZATION STREAM, RECTYPE INTERNAL
110 SET #1: POINTER END, IF MISSING THEN 200
120 PRINT "NO1"
130 STOP
200 PRINT "MISSING-END"
210 SET #1: IF MISSING THEN 300
220 PRINT "NO2"
230 STOP
300 PRINT "MISSING-SOLO"
310 WRITE #1: 1
320 SET #1: POINTER BEGIN, IF THERE THEN 400
330 PRINT "NO3"
340 STOP
400 PRINT "THERE-BEGIN"
410 FOR I = 1 TO 3
420 SET #1: POINTER END, IF MISSING THEN EXIT FOR
430 PRINT "NO4"
440 NEXT I
450 PRINT "FOR"; I
460 CLOSE #1
470 END
