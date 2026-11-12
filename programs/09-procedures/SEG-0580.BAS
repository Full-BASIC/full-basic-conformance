1 REM FBCS SEG-0580
2 REM CLAIM A-9.2.4.2-TR147A
3 REM TYPE OUTPUT
4 REM 9.2.4.2 l.4718-4738: internal SUB called from another internal routine sees the unit array, not the caller formal.
10 DIM V(2), W(2)
20 LET V(1) = 1
30 LET W(1) = 9
40 SUB Q(V())
50   CALL R
60 END SUB
70 SUB R
80   PRINT V(1)
90 END SUB
100 CALL Q(W)
110 END
