1 REM FBCS GFX-0280
2 REM CLAIM A-13.1.4-07
3 REM TYPE GRAPHIC
4 REM STD 13.1.4 l.9322-9330: SET DEVICE WINDOW and SET DEVICE VIEWPORT clear the display surface when
5 REM something has been drawn on it (a clear request follows each set-statement).
100 GRAPH POINTS: 0.5, 0.5
110 SET DEVICE WINDOW 0, 0.5, 0, 0.5
120 GRAPH POINTS: 0.2, 0.2
130 SET DEVICE VIEWPORT 0, 0.1, 0, 0.1
140 END
