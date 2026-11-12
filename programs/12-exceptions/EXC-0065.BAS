1 REM FBCS EXC-0065
2 REM CLAIM A-12.1.4-17
3 REM TYPE OUTPUT
100 REM STD 10.4.4.2 l.5697-5705: the values are generated in sequence; the
110 REM literal before the failing item was already copied ("12/ ") and stays.
115 REM The literal is "/" because the comma is not a literal-item (10.4.2 prod. 8).
120 REM The failing field adds no characters (the asterisks are the
130 REM default recovery of 10.4.5, not applicable under WHEN) and there is no
140 REM final end-of-line (10.4.4.5: the generation did not complete), so
150 REM the PRINT of the handler continues on the same line.
160 WHEN EXCEPTION IN
170   PRINT USING "##/ ##": 12, 123
180 USE
190   PRINT "EXTYPE="; EXTYPE
200 END WHEN
210 END
