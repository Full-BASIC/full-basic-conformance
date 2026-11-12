1 REM FBCS EXC-0111
2 REM CLAIM A-12.1.2-TR89
3 REM TYPE SELF
4 REM A jump inside the when-block, a jump from the handler to its own end-when-line, and a jump to the end-when-line
5 REM of a when-use-name block (not the end of an exception-handler, 12.1.2 prod. 8) stay accepted.
100 REM CONTROLS OF 12.1.2 L.8701-8706: THE RULE REACHES ONLY THE END-WHEN-LINE FROM THE WHEN-BLOCK
110 LET OK = 1
120 WHEN EXCEPTION IN
130   GOTO 150
140   LET OK = 0
150   LET X = 1 / 0
160 USE
170   GOTO 190
180   LET OK = 0
190 END WHEN
200 WHEN EXCEPTION USE H
210   GOTO 230
220   LET OK = 0
230 END WHEN
240 IF OK = 1 THEN PRINT "*** TEST PASSED ***" ELSE PRINT "*** TEST FAILED ***"
250 HANDLER H
260 END HANDLER
270 END
