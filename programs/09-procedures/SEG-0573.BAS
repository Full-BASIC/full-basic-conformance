1 REM FBCS SEG-0573
2 REM CLAIM A-9.2.4.1-TR146B
3 REM TYPE OUTPUT
4 REM STD 4.4.2 l.1450-1454, 9.2.4.1 l.4670-4677: an internal SUB whose name has an underline receives an array by reference.
10 SUB MI_SUB(V())
20 PRINT V(1)
30 LET V(2) = 8
40 END SUB
50 DIM A(3)
60 LET A(1) = 5
70 CALL MI_SUB(A)
80 PRINT A(2)
90 END
