1 REM FBCS EXC-0241
2 REM CLAIM A-12.2.4-TR161
3 REM TYPE OUTPUT
4 REM 12.2.4 l.9119-9142: the report of a main line shows the text of that line, not of the same-numbered line of an external unit.
10 DEBUG ON
20 TRACE ON
30 LET X = 5
40 GOTO 60
50 PRINT "NO"
60 PRINT "M60"
70 END
6 EXTERNAL SUB E
30 LET YY = 7
40 GOSUB 60
60 PRINT "E60"
70 END SUB
