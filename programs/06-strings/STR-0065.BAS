1 REM FBCS STR-0065
2 REM CLAIM A-6.4.4-G03
3 REM TYPE SELF
100 REM In 6.4.4 "M represents an index, i.e., the rounded integer value of some
110 REM numeric-expression" (l.2596-2597); index = INT(X+.5) (5.2.4 l.1700-1702).
120 REM So CHR$(65.4) = CHR$(65) = "A"; REPEAT$("AB",2.5) = REPEAT$("AB",3);
130 REM POS("ABCABC","C",2.6) starts at character INT(2.6+.5) = 3.
140 LET FAIL = 0
150 IF CHR$(65.4) <> "A" THEN LET FAIL = FAIL + 1
160 IF CHR$(53) <> "5" THEN LET FAIL = FAIL + 1
170 IF LEN(CHR$(-.4)) <> 1 THEN LET FAIL = FAIL + 1
180 IF LEN(CHR$(127.4)) <> 1 THEN LET FAIL = FAIL + 1
190 IF REPEAT$("AB", 2.5) <> "ABABAB" THEN LET FAIL = FAIL + 1
200 IF REPEAT$("AB", -.4) <> "" THEN LET FAIL = FAIL + 1
210 IF POS("ABCABC", "C", 2.6) <> 3 THEN LET FAIL = FAIL + 1
220 IF FAIL = 0 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
230 END
