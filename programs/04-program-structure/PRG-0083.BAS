1 REM FBCS PRG-0083
2 REM CLAIM A-4.2.2-09
3 REM TYPE OUTPUT
5 DECLARE EXTERNAL SUB S
6 DECLARE EXTERNAL FUNCTION F
10 CALL S
20 PRINT F(2)
30 END
32 ! first remark-line, a null-statement
34 REM second remark-line, a remark-statement
36   ! third remark-line, indented tail-comment
40 EXTERNAL SUB S
50   PRINT "S"
60 END SUB
70 ! between two procedures
80 EXTERNAL FUNCTION F(X)
90   LET F = X * 3
100 END FUNCTION
