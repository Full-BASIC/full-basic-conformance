1 REM FBCS PRT-0398
2 REM CLAIM A-10.4.4.1-TR174
3 REM TYPE OUTPUT
4 REM STD 10.4.4.1 l.5677-5686: "#.#.#" is "#.#" and ".#"; "##$##" is "##" and "$##".
10 PRINT USING "#.#.#": 1, .5
20 PRINT USING "##$##": 1, 2
30 END
