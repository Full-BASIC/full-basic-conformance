1 REM FBCS PRT-0399
2 REM CLAIM A-10.4.4.1-TR174
3 REM TYPE FATAL
4 REM EXPECT 8201 20
5 REM STD 10.4.2 prod. 8 (closed list of literal-items, no comma), 10.4.5 l.5830:
6 REM "#.#,#" is "#.#" plus a comma that is neither a literal-item nor part of a format-item.
10 PRINT "EXECUTED"
20 PRINT USING "#.#,#": 1, 5
30 END
