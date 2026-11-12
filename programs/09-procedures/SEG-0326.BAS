1 REM FBCS SEG-0326
2 REM CLAIM E-4303
3 REM TYPE OUTPUT
100 OPTION ARITHMETIC NATIVE
110 OPEN #1: NAME "TGT.BAS", ACCESS OUTPUT
120 PRINT #1: "5 PROGRAM T(S$)"
130 PRINT #1: "20 PRINT ""GOT ""; S$"
140 PRINT #1: "30 END"
160 CLOSE #1
170 REM 9.3.5 l.4918-4920 ("Numeric parameters are passed"):
175 REM a single string parameter is not a numeric parameter: no 4303
180 REM although caller NATIVE and callee DECIMAL differ in type.
190 CHAIN "TGT.BAS" WITH ("HI")
200 END
