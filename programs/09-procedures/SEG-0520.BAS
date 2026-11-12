1 REM FBCS SEG-0520
2 REM CLAIM A-9.2.2-TR136
3 REM TYPE OUTPUT
4 REM 9.2.2 l.4534-4537, 12.1.4 l.8805-8807: the detached-handler of an internal SUB of the main program calls the SUB
5 REM itself (a self-recursive subprogram need not declare itself); the arguments are those of the SUB.
20 SUB S(N)
30   WHEN EXCEPTION USE H
40     CAUSE EXCEPTION 5
50   END WHEN
60   PRINT "S"; N
70   HANDLER H
80     IF N < 2 THEN CALL S(N + 1)
90   END HANDLER
100 END SUB
105 CALL S(1)
110 END
