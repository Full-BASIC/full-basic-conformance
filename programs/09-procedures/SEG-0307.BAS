1 REM FBCS SEG-0307
2 REM CLAIM E-4301
3 REM TYPE FATAL
4 REM EXPECT 4301 160
100 OPEN #1: NAME "TGT.BAS", ACCESS OUTPUT
110 PRINT #1: "5 PROGRAM T(A)"
120 PRINT #1: "10 PRINT ""GOT"""
130 PRINT #1: "20 END"
140 CLOSE #1
150 REM The caller's handler need not see this: 9.3.6 l.4929-4932 lets the chained-from program, the
155 REM chained-to program or a system program report it, so the exception is fatal and not caught here.
160 CHAIN "TGT.BAS" WITH (1, 2)
170 END
