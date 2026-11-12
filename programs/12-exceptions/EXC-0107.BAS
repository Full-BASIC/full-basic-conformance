1 REM FBCS EXC-0107
2 REM CLAIM A-12.1.2-TR89
3 REM TYPE REJECT
4 REM STD 12.1.2 l.8701-8706: a GOTO in the when-block (outside the exception-handler) may not name the end-when-line.
100 PRINT "EXECUTED"
110 WHEN EXCEPTION IN
120   GOTO 150
130   PRINT "protected"
140 USE
145   PRINT "handler"
150 END WHEN
160 END
