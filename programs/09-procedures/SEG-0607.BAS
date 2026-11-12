1 REM FBCS SEG-0607
2 REM CLAIM A-9.1.2-TR162
3 REM TYPE OUTPUT
4 REM 9.1.2 l.4194-4205: a string DEF of the main shadows an external string FUNCTION of the same name.
10 DEF Q$(X$) = X$ & "-I"
20 PRINT Q$("A")
30 END
100 EXTERNAL FUNCTION Q$(X$)
110 LET Q$ = X$ & "-E"
120 END FUNCTION
