1 REM FBCS EXC-0064
2 REM CLAIM A-12.1.4-17
3 REM TYPE OUTPUT
100 REM STD 2.4 l.600-602 + 12.1.4 l.8788-8798: with a WHEN active the default
110 REM recovery of 10.4.5 l.5838-5844 (asterisks + the unformatted value
120 REM on the next line) does not apply: PRINT USING writes nothing and the
130 REM handler recibe EXTYPE = 8203.
140 WHEN EXCEPTION IN
150   PRINT USING "##": 123
160 USE
170   PRINT "EXTYPE="; EXTYPE
180 END WHEN
190 END
