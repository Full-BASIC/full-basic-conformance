1 REM FBCS GFX-0049
2 REM CLAIM A-13.3.2-02
3 REM TYPE REJECT
4 REM EXECUTED is printed first, to tell a load-time rejection from a run-time failure (13.3.2 l.9856-9857, 2.3 l.580-584).
100 PRINT "EXECUTED"
110 DIM A(5)
120 MAT GRAPH CELLS, IN 0,0; 1,1: A
130 END
