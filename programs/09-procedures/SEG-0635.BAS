1 REM FBCS SEG-0635
2 REM CLAIM A-4.4.2-TR165
3 REM TYPE OUTPUT
4 REM 4.4.2 l.1460-1470: a variable of the name of an internal SUB declared with DECLARE SUB and called before its definition.
10 DECLARE SUB Q
20 LET Q = 3
30 CALL Q
40 PRINT Q
50 SUB Q
60 PRINT "S"
70 END SUB
90 END
