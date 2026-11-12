1 REM FBCS FIL-0565
2 REM CLAIM A-11.3.4.11-CL06
3 REM TYPE OUTPUT
4 REM STD 11.3.4.11 l.7757-7761: an omitted integer-size is treated as zero, so a numeric value with significant
5 REM digits to the left of the point has no available position and gives 8255 (fatal); digits to the right are rounded.
10 OPEN #1: NAME "FIL0565.DAT", ACCESS OUTIN, ORGANIZATION SEQUENTIAL, RECTYPE NATIVE
20 ERASE #1
30 TEMPLATE: NUMERIC*.3
40 TEMPLATE: NUMERIC*0.3
110 FOR K = 1 TO 6
120   READ V
130   WHEN EXCEPTION IN
140     ERASE #1
150     WRITE #1, WITH 30: V
160     READ #1, BEGIN, WITH 40: A
170     PRINT V; "->"; A
180   USE
190     PRINT V; "->"; EXTYPE
200   END WHEN
210 NEXT K
220 DATA 1.5, -1.5, .9996, .5, -.5, .0004
230 END
