1 REM FBCS GFX-0192
2 REM CLAIM A-13.5.2-TR136
3 REM TYPE OUTPUT
4 REM 13.5.2 l.10527-10530, 12.1.4 l.8805-8807: the detached-handler of an internal picture of the main program draws the
5 REM picture itself (a self-recursive picture need not declare itself).
20 PICTURE Q(N)
30   WHEN EXCEPTION USE H
40     CAUSE EXCEPTION 5
50   END WHEN
60   PRINT "Q"; N
70   HANDLER H
80     IF N < 2 THEN DRAW Q(N + 1)
90   END HANDLER
100 END PICTURE
105 DRAW Q(1)
110 END
