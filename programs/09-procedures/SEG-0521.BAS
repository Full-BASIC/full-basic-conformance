1 REM FBCS SEG-0521
2 REM CLAIM A-9.1.2-TR136
3 REM TYPE OUTPUT
4 REM 9.1.2 l.4220-4223, 12.1.4 l.8805-8807: the detached-handler of an internal FUNCTION of the main program invokes
5 REM the FUNCTION itself (a self-recursive function need not declare itself).
20 FUNCTION F(N)
30   WHEN EXCEPTION USE H
40     CAUSE EXCEPTION 5
50   END WHEN
55   EXIT FUNCTION
70   HANDLER H
80     IF N < 3 THEN LET F = 10 * F(N + 1) ELSE LET F = N
90   END HANDLER
100 END FUNCTION
105 PRINT F(1)
110 END
