1 REM FBCS SEG-0581
2 REM CLAIM A-9.2.4.2-TR147A
3 REM TYPE OUTPUT
4 REM 9.2.4.2 l.4718-4738: assignment in internal SUB reached from another with a homonymous formal goes to the unit array.
10 DIM V(2), W(2)
20 LET V(1) = 1
30 LET W(1) = 9
40 SUB Q(V())
50   CALL R
60 END SUB
70 SUB R
80   LET V(1) = 5
90 END SUB
100 CALL Q(W)
110 PRINT V(1); W(1)
120 END
