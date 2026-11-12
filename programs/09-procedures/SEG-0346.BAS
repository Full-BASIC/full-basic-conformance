1 REM FBCS SEG-0346
2 REM CLAIM A-9.1.4.1-03
3 REM TYPE SELF
100 REM While an internal function runs, its formal array is a copy
110 REM distinct from the global array of the same name (9.1.4.3 l.4373-4377), in both
120 REM directions, for a numeric and a string array
130 DIM A(2), S$(2)
140 LET A(1) = 1
150 LET S$(1) = "one"
160 DECLARE FUNCTION F, G$
170 LET R = F(A)
180 LET T$ = G$(S$)
190 IF R = 1050 AND A(1) = 70 AND T$ = "onetwo" AND S$(1) = "one" THEN
195 PRINT "*** TEST PASSED ***"
196 ELSE
197 PRINT "*** TEST FAILED ***"; R; A(1); T$; S$(1)
198 END IF
200 FUNCTION F(V())
210 LET V(1) = 50
220 LET X = A(1)
230 LET A(1) = 70
240 LET F = X * 1000 + V(1)
250 END FUNCTION
260 FUNCTION G$(V$())
270 LET V$(1) = "two"
280 LET X$ = S$(1)
290 LET G$ = X$ & V$(1)
300 END FUNCTION
310 END
