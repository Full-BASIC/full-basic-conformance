1 REM FBCS GFX-0281
2 REM CLAIM A-13.1.4-08
3 REM TYPE GRAPHIC
4 REM STD 13.1.4 l.9322-9330: no clear is requested when the display surface is already clear (at the
5 REM start, after CLEAR, after an earlier device set-statement) nor by SET WINDOW and SET VIEWPORT.
100 SET DEVICE WINDOW 0, 0.5, 0, 0.5
110 SET DEVICE VIEWPORT 0, 0.1, 0, 0.1
120 GRAPH POINTS: 0.5, 0.5
130 CLEAR
140 SET DEVICE WINDOW 0, 1, 0, 1
150 GRAPH POINTS: 0.4, 0.4
160 SET WINDOW 0, 2, 0, 2
170 SET VIEWPORT 0, 0.5, 0, 0.5
180 END
