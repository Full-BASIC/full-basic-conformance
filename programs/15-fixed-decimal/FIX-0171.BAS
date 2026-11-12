1 REM FBCS FIX-0171
2 REM CLAIM D-15.1-4
3 REM TYPE OUTPUT
4 REM A negated constant is an expression (5.3.2 prod. 2); its digits are implementation-defined (l.12250-12259)
5 REM Here: default size *8.2 limited to P = 18 digits in all (17 integer digits leave scale 1, 18 leave scale 0)
10 OPTION ARITHMETIC FIXED*8.2
20 PRINT -1234567
30 PRINT -12345678901234567
40 PRINT -123456789012345678
50 PRINT 12345678901234567
60 END
