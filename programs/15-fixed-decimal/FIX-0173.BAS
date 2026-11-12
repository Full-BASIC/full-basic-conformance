1 REM FBCS FIX-0173
2 REM CLAIM E-1010
3 REM TYPE FATAL
4 REM EXPECT 1010 30
5 REM Accepted at load time; 1010 is raised when line 30 executes, after line 20 output (15.1.5; 2.4)
10 PRINT "before"
20 PRINT "still before"
30 OPTION ARITHMETIC FIXED*30.10
40 PRINT "after"
50 END
