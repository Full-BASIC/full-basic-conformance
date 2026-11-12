1 REM FBCS PRT-0402
2 REM CLAIM A-10.4.4.3-TR175
3 REM TYPE OUTPUT
4 REM STD 10.4.4.3, table of leading characters: first plus-sign and last dollar-sign give "+$" (non-negative) and "-$" (negative).
10 PRINT USING "+$##.##": 12.5
20 PRINT USING "+$##.##": -12.5
30 PRINT USING "+$###.##": 1.5
40 END
