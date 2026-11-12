1 REM FBCS FIL-0032
2 REM CLAIM A-11.1.2-01
3 REM TYPE REJECT
4 REM STD 11.1.2 l.6540-6541: a given file-attribute appears at most once in a
5 REM file-attribute-list. NAME is not a file-attribute: ACCESS is.
100 PRINT "EXECUTED"
110 OPEN #1: NAME "FIL0032.DAT", ACCESS OUTIN, ACCESS INPUT
120 END
