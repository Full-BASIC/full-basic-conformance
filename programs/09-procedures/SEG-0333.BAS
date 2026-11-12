1 REM FBCS SEG-0333
2 REM CLAIM A-9.2.4.1-11
3 REM TYPE OUTPUT
100 REM A string-array parameter passed by reference has the
110 REM maximum length of its argument (9.2.4.1 l.4679-4683), also when forwarded
119 DECLARE SUB U
120 DECLARE STRING L$(2)*4
130 SUB T(M$())
140   PRINT MAXLEN(M$)
150   CALL U(M$)
160 END SUB
170 SUB U(N$())
180   PRINT MAXLEN(N$)
190 END SUB
200 CALL T(L$)
210 END
