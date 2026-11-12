1 REM FBCS SEG-0621
2 REM CLAIM A-4.4.2-TR164
3 REM TYPE REJECT
4 REM 4.4.2 l.1468-1470: an identifier may not name both an internal-sub-def and an internal-picture-def.
6 PRINT "EXECUTED"
10 SUB Q
20 PRINT "S"
30 END SUB
40 PICTURE Q
45 PRINT "P"
48 END PICTURE
50 CALL Q
90 END
