1 REM FBCS EXC-0076
2 REM CLAIM A-12.1.4-04
3 REM TYPE INPUT
100 REM STD 12.1.3 example 1 (l.8722-8736): the INPUT fails in the
110 REM second statement of the when-block; RETRY repeats only that statement.
120 WHEN EXCEPTION IN
130 PRINT "Enter your age and weight"
140 INPUT a, w
150 IF a > 10 THEN
160 PRINT "What is your height"
170 INPUT h
180 END IF
190 USE
200 PRINT "Please enter numbers only"
210 RETRY
220 END WHEN
230 PRINT a; w; h
240 END
