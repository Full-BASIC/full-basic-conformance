1 REM FBCS SEG-0277
2 REM CLAIM A-9.2.4.1-09
3 REM TYPE SELF
4 REM Redimensioning a formal array redimensions the caller's array (9.2.4.1 l.4670-4674).
5 REM The redim is done with MAT ... = ZER(3), within the 10 elements reserved by DIM A(9):
6 REM a DIM of a parameter is illegal (9.2.2 l.4573-4576) and a redim cannot grow the array (5001, 7.2.5).
99 DECLARE SUB S
100 DIM A(9)
110 CALL S(A)
120 IF UBOUND(A,1) = 3 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"; UBOUND(A,1)
130 SUB S(B())
140 MAT B = ZER(3)
150 END SUB
160 END
