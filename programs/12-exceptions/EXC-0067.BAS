1 REM FBCS EXC-0067
2 REM CLAIM A-12.1.4-19
3 REM TYPE OUTPUT
100 REM STD 6.4.4 l.2720-2723 (the exceptions of 10.4.5 apply to USING$)
110 REM + 2.4 l.600-602 + 12.1.4: under WHEN the invocation is aborted without
120 REM returning a value (the string of asterisks is the default recovery
130 REM of 10.4.5, not the value of 6.4.4); X$ keeps "PREV".
140 LET X$ = "PREV"
150 WHEN EXCEPTION IN
160   LET X$ = USING$("##", 123)
170 USE
180   PRINT "X=["; X$; "] E="; EXTYPE
190 END WHEN
200 END
