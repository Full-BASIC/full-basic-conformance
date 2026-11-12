1 REM FBCS EXC-0262
2 REM CLAIM A-12.1.2-E26
3 REM TYPE REJECT
4 REM 12.1.2 l.8689-8691: EXTYPE/EXLINE shall be invoked only within exception-handlers; referencing a DEF whose
5 REM expression uses them, outside any handler, invokes them outside a handler.
100 DEF F = EXTYPE * 10 + EXLINE
110 PRINT "EXECUTED"
120 PRINT F
130 END
