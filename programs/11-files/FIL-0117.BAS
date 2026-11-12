1 REM FBCS FIL-0117
2 REM CLAIM A-11.3.2-09
3 REM TYPE REJECT
4 REM STD 11.3.2 l.7468-7469: the record-setter in a write-control shall not specify
5 REM an inexact-search. Static rule (2.3 l.580-587): rejected at load, nothing runs.
100 PRINT "EXECUTED"
110 OPEN #1: NAME "FIL0117.DAT", ACCESS OUTIN, ORGANIZATION KEYED, RECTYPE DISPLAY
120 WRITE #1, KEY "A": "FIRST"
130 WRITE #1, KEY > "A": "SECOND"
140 END
