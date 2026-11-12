1 REM FBCS PRT-0139
2 REM CLAIM A-10.4.3-EX
3 REM TYPE SELF
90 REM Lines 130-140 follow the printed text (p. 123), not the garbled transcription (">-$", trailing ".").
100 REM EXAMPLES 4,6,7 OF 10.4.3 RUN TO COMPLETION PER THE NORMATIVE RULES (l.5621, l.5693, l.5710, l.5796)
110 PRINT USING 120: "ONE", "TWO", "THREE"
120 IMAGE : Z<####>#### ########Z
130 PRINT USING "<%%.## >---$##.## $$$+***": 3.1, -1234.567, 2
140 PRINT USING "<$$$$.## $$$$.###^^^^^": -.02, -.02
150 PRINT "*** TEST PASSED ***"
160 END
