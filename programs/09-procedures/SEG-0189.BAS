1 REM FBCS SEG-0189
2 REM CLAIM A-9-01
3 REM TYPE REJECT
4 REM An internal function is invoked on a line before the line that defines it. Unlike an
5 REM internal SUB (9.2.6 l.4771-4774), no clause lets an implementation accept this (9.1.2 l.4104-4106).
100 PRINT "EXECUTED"
110 LET X = FNA(1)
120 DEF FNA(Y) = Y + 1
130 END
