1 REM FBCS GFX-0270
2 REM CLAIM A-13.5.2-TR159
3 REM TYPE GRAPHIC
4 REM STD 13.5.2 l.10506-10525: an internal picture of the main program takes precedence over an external
5 REM picture of the same name for the DRAWs of the main program (no DECLARE EXTERNAL PICTURE needed).
20 PICTURE Q
30 PLOT POINTS: 1,1
40 END PICTURE
45 DRAW Q
50 END
200 EXTERNAL PICTURE Q
230 PLOT POINTS: 2,2
250 END PICTURE
