1 REM FBCS SEG-0632
2 REM CLAIM A-4.4.2-TR165
3 REM TYPE OUTPUT
4 REM 4.4.2 l.1460-1470: an array and an internal SUB of the main program may have the same name.
10 SUB Q
20 PRINT "S"
30 END SUB
40 DIM Q(3)
50 LET Q(1) = 2
60 CALL Q
70 PRINT Q(1)
90 END
