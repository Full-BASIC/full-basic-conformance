1 REM FBCS EXC-0082
2 REM CLAIM D-12.2-2
3 REM TYPE OUTPUT
100 REM Control: without TO, the [TRACE] report and the "Trace mode" message go to channel 0 (the console)
110 DEBUG ON
120 TRACE ON
130 LET A = 42
140 TRACE OFF
150 PRINT "END"
160 END
