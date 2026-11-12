1 REM FBCS PRT-0400
2 REM CLAIM A-10.4.4.1-TR174
3 REM TYPE FATAL
4 REM EXPECT 8201 20
5 REM STD 10.4.2 prod. 8, 10.4.5 l.5830: a final plus-sign belongs to no format-item
6 REM and is not a literal-item, so the format-string is invalid.
10 PRINT "EXECUTED"
20 PRINT USING "###+": 5
30 END
