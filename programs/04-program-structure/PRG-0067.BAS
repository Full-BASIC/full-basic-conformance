1 REM FBCS PRG-0067
2 REM CLAIM A-4.4.4-08
3 REM TYPE OUTPUT
100 REM A user-defined string function may be named UCASE$ (4.4.4 l.1511-1518)
110 DEF UCASE$(X$) = X$ & "!"
120 PRINT UCASE$("a")
130 END
