1 REM FBCS PRT-0087
2 REM CLAIM A-10.4.2-04
3 REM TYPE FATAL
4 REM EXPECT 8201 110
5 REM A format string may be evaluated dynamically, so an error in it may be an exception
6 REM (10.4.6 l.5851-5854); the invalid format string is exception 8201 (10.4.5 l.5831-5832).
REM A run of different digit-places splits into several format-items (10.4.4.1 l.5675-5686), but
REM "#,%" has no valid reading: a comma needs digit-places of the same character on both sides
REM (10.4.2 l.5625-5627) and the comma is not a literal-item (l.5586-5593).
100 PRINT "EXECUTED"
110 PRINT USING "#,%": 1
120 END
