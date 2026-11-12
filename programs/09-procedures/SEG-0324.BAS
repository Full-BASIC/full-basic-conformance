1 REM FBCS SEG-0324
2 REM CLAIM A-9.3.5-01
3 REM TYPE SELF
100 OPTION ARITHMETIC FIXED *4.2
110 OPEN #1: NAME "TGT.BAS", ACCESS OUTPUT
120 PRINT #1: "5 PROGRAM T(N)"
130 PRINT #1: "10 OPTION ARITHMETIC FIXED *8.2"
140 PRINT #1: "20 IF N=10 THEN PRINT ""*** TEST PASSED ***"" ELSE PRINT ""*** TEST FAILED ***""; N"
150 PRINT #1: "30 END"
160 CLOSE #1
170 REM Agreed interpretation of 15.2.2: l.12354-12357 requires the ARITHMETIC options
175 REM to agree only in TYPE (both FIXED here); the different precision
180 REM (*4.2 vs *8.2) does NOT give 4303 (9.3.5 l.4918-4920). The parameters of the
185 REM program-name-line do not count for the ordering rule of 15.1.2 l.12145-12148.
190 CHAIN "TGT.BAS" WITH (10)
200 PRINT "*** TEST FAILED: CHAIN RETURNED ***"
210 END
