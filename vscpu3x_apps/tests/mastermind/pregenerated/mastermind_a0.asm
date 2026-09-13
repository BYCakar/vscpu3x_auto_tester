0: BZJi 3 20 // Goto init
//$REGISTERS_SECTION
1: 0 // SP (unused - stackless spills use static cells)
2: 0 // BP (unused - stackless calling convention)
3: 0 // CONST_ZERO
4: 1 // CONST_ONE
5: 0 // CONST_NEG_ONE (computed)
6: 0 // reserved
7: 0 // reserved
8: 0 // reserved
9: 0 // reserved
10: 0 // reserved
11: 0 // reserved
12: 0 // reserved
13: 0 // reserved
14: 0 // TEMP1
15: 0 // TEMP2
16: 0 // TEMP3
17: 0 // TEMP4
18: 0 // TEMP5
19: 0 // TEMP6
//$TEXT_SECTION
20: NAND 5 3 // CONST_NEG_ONE = ~(0&0)
21: CPi 18 872 // $RA.main addr
22: CPi 15 865 // HALT addr
23: CPIi 18 15 // RA.main = HALT
24: BZJi 3 562 // Goto main
25: CPi 875 0 // init local
26: CP 14 875 // $slot.BCD_inc.0
27: NAND 14 14 // ~
28: CP 875 14 // direct store
29: CPi 877 1 // direct assignment
30: CP 14 877 // $slot.BCD_inc.2
31: CPi 15 4 // constant operand
32: CPi 19 8 // sign bias
33: SRLi 19 60 // 2^31
34: ADD 14 19 // signed lhs bias
35: ADD 15 19 // signed rhs bias
36: LT 15 14 // b<a
37: CP 14 15
38: LTi 14 1 // !
39: CPi 18 145 // condition (P)
40: BZJ 18 14 // condition
41: CPi 14 7 // constant
42: CP 873 14 // spill lhs
43: CPi 14 4 // constant
44: CP 874 14 // spill lhs
45: CP 14 877 // $slot.BCD_inc.2
46: CP 15 4 // constant operand
47: CP 16 15 // sub
48: NAND 16 16 // ~
49: ADDi 16 1 // -src
50: ADD 14 16 // a-b
51: CP 15 14 // rhs
52: CP 14 874 // reload lhs
53: MUL 14 15 // *
54: CP 15 14 // rhs
55: CP 14 873 // reload lhs
56: CP 16 15 // shift amount
57: LTi 16 32 // amount<32?
58: CPi 18 64 // shift>=32 (P)
59: BZJ 18 16 // shift>=32
60: ADDi 15 32 // left shift encoding
61: SRL 14 15 // <<
62: CPi 18 65 // shift end (P)
63: BZJi 18 0 // shift end
64: CPi 14 0 // shift>=32
65: CP 876 14 // direct store
66: CP 14 868 // AG_candidate
67: CP 15 876 // $slot.BCD_inc.1
68: NAND 14 15 // nand
69: NAND 14 14 // and
70: CP 15 876 // $slot.BCD_inc.1
71: CP 16 15 // sub
72: NAND 16 16 // ~
73: ADDi 16 1 // -src
74: ADD 14 16 // a-b
75: CPi 18 79 // condition fallthrough (P)
76: BZJ 18 14 // condition fallthrough
77: CPi 18 81 // condition (P)
78: BZJi 18 0 // condition
79: CPi 18 142 // continue (P)
80: BZJi 18 0 // continue
81: CP 14 875 // $slot.BCD_inc.0
82: CP 873 14 // spill lhs
83: CPi 14 4 // constant
84: CP 874 14 // spill lhs
85: CP 14 877 // $slot.BCD_inc.2
86: CP 15 4 // constant operand
87: CP 16 15 // sub
88: NAND 16 16 // ~
89: ADDi 16 1 // -src
90: ADD 14 16 // a-b
91: CP 15 14 // rhs
92: CP 14 874 // reload lhs
93: MUL 14 15 // *
94: CP 15 14 // rhs
95: CP 14 873 // reload lhs
96: CP 16 15 // shift amount
97: LTi 16 32 // amount<32?
98: CPi 18 104 // shift>=32 (P)
99: BZJ 18 16 // shift>=32
100: ADDi 15 32 // left shift encoding
101: SRL 14 15 // <<
102: CPi 18 105 // shift end (P)
103: BZJi 18 0 // shift end
104: CPi 14 0 // shift>=32
105: CP 876 14 // direct store
106: CP 14 868 // AG_candidate
107: CP 15 876 // $slot.BCD_inc.1
108: NAND 14 15 // nand
109: NAND 14 14 // and
110: CP 868 14 // direct store
111: CP 14 4 // constant
112: CP 873 14 // spill lhs
113: CPi 14 4 // constant
114: CP 874 14 // spill lhs
115: CP 14 877 // $slot.BCD_inc.2
116: CP 15 4 // constant operand
117: CP 16 15 // sub
118: NAND 16 16 // ~
119: ADDi 16 1 // -src
120: ADD 14 16 // a-b
121: CP 15 14 // rhs
122: CP 14 874 // reload lhs
123: MUL 14 15 // *
124: CP 15 14 // rhs
125: CP 14 873 // reload lhs
126: CP 16 15 // shift amount
127: LTi 16 32 // amount<32?
128: CPi 18 134 // shift>=32 (P)
129: BZJ 18 16 // shift>=32
130: ADDi 15 32 // left shift encoding
131: SRL 14 15 // <<
132: CPi 18 135 // shift end (P)
133: BZJi 18 0 // shift end
134: CPi 14 0 // shift>=32
135: CP 876 14 // direct store
136: CP 14 868 // AG_candidate
137: CP 15 876 // $slot.BCD_inc.1
138: ADD 14 15 // +
139: CP 868 14 // direct store
140: CPi 18 145 // break (P)
141: BZJi 18 0 // break
142: ADDi 877 1 // direct ++
143: CPi 18 30 // for
144: BZJi 18 0 // loop
145: CP 14 3 // ret 0
146: CPi 18 869 // $RA.BCD_inc
147: CPI 15 18 // load RA
148: BZJi 15 0 // return
149: CP 14 882 // $slot.BCD_compare_digit.2
150: CP 15 883 // $slot.BCD_compare_digit.3
151: CPi 19 8 // sign bias
152: SRLi 19 60 // 2^31
153: ADD 14 19 // signed lhs bias
154: ADD 15 19 // signed rhs bias
155: LT 15 14 // >
156: CP 14 15
157: CPi 18 195 // condition (P)
158: BZJ 18 14 // condition
159: CP 884 883 // direct assignment
160: CP 14 880 // $slot.BCD_compare_digit.0
161: CP 878 14 // spill lhs
162: CPi 14 4 // constant
163: CP 879 14 // spill lhs
164: CP 14 882 // $slot.BCD_compare_digit.2
165: CP 15 883 // $slot.BCD_compare_digit.3
166: CP 16 15 // sub
167: NAND 16 16 // ~
168: ADDi 16 1 // -src
169: ADD 14 16 // a-b
170: CP 15 14 // rhs
171: CP 14 879 // reload lhs
172: MUL 14 15 // *
173: CP 15 14 // rhs
174: CP 14 878 // reload lhs
175: CP 16 15 // shift amount
176: LTi 16 32 // amount<32?
177: CPi 18 191 // shift>=32 (P)
178: BZJ 18 16 // shift>=32
179: CP 16 14 // shift sign
180: SRLi 16 31 // negative?
181: CPi 18 188 // nonnegative shift (P)
182: BZJ 18 16 // nonnegative shift
183: NAND 14 14 // ~negative
184: SRL 14 15 // >>
185: NAND 14 14 // sign extension
186: CPi 18 189 // shift end (P)
187: BZJi 18 0 // shift end
188: SRL 14 15 // >>
189: CPi 18 192 // shift end (P)
190: BZJi 18 0 // shift end
191: CPi 14 0 // shift>=32
192: CP 880 14 // direct store
193: CPi 18 229 // if end (P)
194: BZJi 18 0 // if end
195: CP 884 882 // direct assignment
196: CP 14 881 // $slot.BCD_compare_digit.1
197: CP 878 14 // spill lhs
198: CPi 14 4 // constant
199: CP 879 14 // spill lhs
200: CP 14 883 // $slot.BCD_compare_digit.3
201: CP 15 882 // $slot.BCD_compare_digit.2
202: CP 16 15 // sub
203: NAND 16 16 // ~
204: ADDi 16 1 // -src
205: ADD 14 16 // a-b
206: CP 15 14 // rhs
207: CP 14 879 // reload lhs
208: MUL 14 15 // *
209: CP 15 14 // rhs
210: CP 14 878 // reload lhs
211: CP 16 15 // shift amount
212: LTi 16 32 // amount<32?
213: CPi 18 227 // shift>=32 (P)
214: BZJ 18 16 // shift>=32
215: CP 16 14 // shift sign
216: SRLi 16 31 // negative?
217: CPi 18 224 // nonnegative shift (P)
218: BZJ 18 16 // nonnegative shift
219: NAND 14 14 // ~negative
220: SRL 14 15 // >>
221: NAND 14 14 // sign extension
222: CPi 18 225 // shift end (P)
223: BZJi 18 0 // shift end
224: SRL 14 15 // >>
225: CPi 18 228 // shift end (P)
226: BZJi 18 0 // shift end
227: CPi 14 0 // shift>=32
228: CP 881 14 // direct store
229: CP 14 880 // $slot.BCD_compare_digit.0
230: CP 878 14 // spill lhs
231: CP 14 881 // $slot.BCD_compare_digit.1
232: NAND 14 14 // ~
233: CP 15 14 // rhs
234: CP 14 878 // reload lhs
235: NAND 14 15 // nand
236: NAND 14 14 // and
237: CP 878 14 // spill lhs
238: CP 14 880 // $slot.BCD_compare_digit.0
239: NAND 14 14 // ~
240: CP 15 881 // $slot.BCD_compare_digit.1
241: NAND 14 15 // nand
242: NAND 14 14 // and
243: CP 15 14 // rhs
244: CP 14 878 // reload lhs
245: CP 16 14 // or
246: NAND 16 16 // ~a
247: CP 17 15
248: NAND 17 17 // ~b
249: NAND 16 17 // a|b
250: CP 14 16
251: CP 882 14 // direct store
252: CP 14 882 // $slot.BCD_compare_digit.2
253: CP 878 14 // spill lhs
254: CP 14 884 // $slot.BCD_compare_digit.4
255: CP 15 4 // constant operand
256: CP 16 15 // sub
257: NAND 16 16 // ~
258: ADDi 16 1 // -src
259: ADD 14 16 // a-b
260: CPi 15 4 // constant operand
261: MUL 14 15 // *
262: CP 15 14 // rhs
263: CP 14 878 // reload lhs
264: CP 16 15 // shift amount
265: LTi 16 32 // amount<32?
266: CPi 18 280 // shift>=32 (P)
267: BZJ 18 16 // shift>=32
268: CP 16 14 // shift sign
269: SRLi 16 31 // negative?
270: CPi 18 277 // nonnegative shift (P)
271: BZJ 18 16 // nonnegative shift
272: NAND 14 14 // ~negative
273: SRL 14 15 // >>
274: NAND 14 14 // sign extension
275: CPi 18 278 // shift end (P)
276: BZJi 18 0 // shift end
277: SRL 14 15 // >>
278: CPi 18 281 // shift end (P)
279: BZJi 18 0 // shift end
280: CPi 14 0 // shift>=32
281: CP 882 14 // direct store
282: CP 880 5 // direct assignment
283: CP 14 880 // $slot.BCD_compare_digit.0
284: CPi 15 15 // constant operand
285: CP 16 15 // sub
286: NAND 16 16 // ~
287: ADDi 16 1 // -src
288: ADD 14 16 // a-b
289: CP 880 14 // direct store
290: CP 14 882 // $slot.BCD_compare_digit.2
291: CP 15 880 // $slot.BCD_compare_digit.0
292: NAND 14 15 // nand
293: NAND 14 14 // and
294: CP 881 14 // direct store
295: CP 14 881 // $slot.BCD_compare_digit.1
296: CP 15 882 // $slot.BCD_compare_digit.2
297: CP 16 15 // sub
298: NAND 16 16 // ~
299: ADDi 16 1 // -src
300: ADD 14 16 // a-b
301: CPi 18 305 // condition fallthrough (P)
302: BZJ 18 14 // condition fallthrough
303: CPi 18 309 // condition (P)
304: BZJi 18 0 // condition
305: CP 14 4 // constant
306: CPi 18 870 // $RA.BCD_compare_digit
307: CPI 15 18 // load RA
308: BZJi 15 0 // return
309: CP 14 3 // constant
310: CPi 18 870 // $RA.BCD_compare_digit
311: CPI 15 18 // load RA
312: BZJi 15 0 // return
313: CP 14 3 // ret 0
314: CPi 18 870 // $RA.BCD_compare_digit
315: CPI 15 18 // load RA
316: BZJi 15 0 // return
317: CPi 866 0 // direct assignment
318: CPi 867 0 // direct assignment
319: CPi 888 0 // init local
320: CPi 889 0 // init local
321: CPi 890 1 // direct assignment
322: CP 14 890 // $slot.score.4
323: CPi 15 4 // constant operand
324: CPi 19 8 // sign bias
325: SRLi 19 60 // 2^31
326: ADD 14 19 // signed lhs bias
327: ADD 15 19 // signed rhs bias
328: LT 15 14 // b<a
329: CP 14 15
330: LTi 14 1 // !
331: CPi 18 412 // condition (P)
332: BZJ 18 14 // condition
333: CP 14 4 // constant
334: CP 885 14 // spill lhs
335: CP 14 890 // $slot.score.4
336: CP 15 4 // constant operand
337: CP 16 15 // sub
338: NAND 16 16 // ~
339: ADDi 16 1 // -src
340: ADD 14 16 // a-b
341: CP 15 14 // rhs
342: CP 14 885 // reload lhs
343: CP 16 15 // shift amount
344: LTi 16 32 // amount<32?
345: CPi 18 351 // shift>=32 (P)
346: BZJ 18 16 // shift>=32
347: ADDi 15 32 // left shift encoding
348: SRL 14 15 // <<
349: CPi 18 352 // shift end (P)
350: BZJi 18 0 // shift end
351: CPi 14 0 // shift>=32
352: CP 892 14 // direct store
353: CP 14 888 // $slot.score.2
354: CP 15 889 // $slot.score.3
355: CP 16 14 // or
356: NAND 16 16 // ~a
357: CP 17 15
358: NAND 17 17 // ~b
359: NAND 16 17 // a|b
360: CP 14 16
361: CP 15 892 // $slot.score.6
362: NAND 14 15 // nand
363: NAND 14 14 // and
364: CP 15 892 // $slot.score.6
365: CP 16 15 // sub
366: NAND 16 16 // ~
367: ADDi 16 1 // -src
368: ADD 14 16 // a-b
369: CPi 18 373 // condition fallthrough (P)
370: BZJ 18 14 // condition fallthrough
371: CPi 18 375 // condition (P)
372: BZJi 18 0 // condition
373: CPi 18 409 // continue (P)
374: BZJi 18 0 // continue
375: CP 14 886 // $slot.score.0
376: CPi 18 880 // $slot.BCD_compare_digit.0
377: CPIi 18 14 // st param
378: CP 14 887 // $slot.score.1
379: CPi 18 881 // $slot.BCD_compare_digit.1
380: CPIi 18 14 // st param
381: CP 14 890 // $slot.score.4
382: CPi 18 882 // $slot.BCD_compare_digit.2
383: CPIi 18 14 // st param
384: CP 14 890 // $slot.score.4
385: CPi 18 883 // $slot.BCD_compare_digit.3
386: CPIi 18 14 // st param
387: CPi 18 870 // $RA.BCD_compare_digit
388: CPi 15 392 // retPC
389: CPIi 18 15 // st RA
390: CPi 18 149 // BCD_compare_digit
391: BZJi 18 0 // BCD_compare_digit
392: CP 891 14 // direct store
393: CP 14 891 // $slot.score.5
394: CPi 18 409 // condition (P)
395: BZJ 18 14 // condition
396: CP 14 888 // $slot.score.2
397: CP 15 892 // $slot.score.6
398: CP 16 14 // or
399: NAND 16 16 // ~a
400: CP 17 15
401: NAND 17 17 // ~b
402: NAND 16 17 // a|b
403: CP 14 16
404: CP 888 14 // direct store
405: CP 889 888 // direct assignment
406: ADDi 866 1 // direct ++
407: CPi 18 409 // continue (P)
408: BZJi 18 0 // continue
409: ADDi 890 1 // direct ++
410: CPi 18 322 // for
411: BZJi 18 0 // loop
412: CPi 890 1 // direct assignment
413: CP 14 890 // $slot.score.4
414: CPi 15 4 // constant operand
415: CPi 19 8 // sign bias
416: SRLi 19 60 // 2^31
417: ADD 14 19 // signed lhs bias
418: ADD 15 19 // signed rhs bias
419: LT 15 14 // b<a
420: CP 14 15
421: LTi 14 1 // !
422: CPi 18 558 // condition (P)
423: BZJ 18 14 // condition
424: CPi 893 1 // direct assignment
425: CP 14 893 // $slot.score.7
426: CPi 15 4 // constant operand
427: CPi 19 8 // sign bias
428: SRLi 19 60 // 2^31
429: ADD 14 19 // signed lhs bias
430: ADD 15 19 // signed rhs bias
431: LT 15 14 // b<a
432: CP 14 15
433: LTi 14 1 // !
434: CPi 18 555 // condition (P)
435: BZJ 18 14 // condition
436: CP 14 4 // constant
437: CP 885 14 // spill lhs
438: CP 14 890 // $slot.score.4
439: CP 15 4 // constant operand
440: CP 16 15 // sub
441: NAND 16 16 // ~
442: ADDi 16 1 // -src
443: ADD 14 16 // a-b
444: CP 15 14 // rhs
445: CP 14 885 // reload lhs
446: CP 16 15 // shift amount
447: LTi 16 32 // amount<32?
448: CPi 18 454 // shift>=32 (P)
449: BZJ 18 16 // shift>=32
450: ADDi 15 32 // left shift encoding
451: SRL 14 15 // <<
452: CPi 18 455 // shift end (P)
453: BZJi 18 0 // shift end
454: CPi 14 0 // shift>=32
455: CP 892 14 // direct store
456: CP 14 4 // constant
457: CP 885 14 // spill lhs
458: CP 14 893 // $slot.score.7
459: CP 15 4 // constant operand
460: CP 16 15 // sub
461: NAND 16 16 // ~
462: ADDi 16 1 // -src
463: ADD 14 16 // a-b
464: CP 15 14 // rhs
465: CP 14 885 // reload lhs
466: CP 16 15 // shift amount
467: LTi 16 32 // amount<32?
468: CPi 18 474 // shift>=32 (P)
469: BZJ 18 16 // shift>=32
470: ADDi 15 32 // left shift encoding
471: SRL 14 15 // <<
472: CPi 18 475 // shift end (P)
473: BZJi 18 0 // shift end
474: CPi 14 0 // shift>=32
475: CP 894 14 // direct store
476: CP 14 888 // $slot.score.2
477: CP 15 892 // $slot.score.6
478: NAND 14 15 // nand
479: NAND 14 14 // and
480: CP 15 892 // $slot.score.6
481: CP 16 15 // sub
482: NAND 16 16 // ~
483: ADDi 16 1 // -src
484: ADD 14 16 // a-b
485: CPi 18 508 // condition (P)
486: BZJ 18 14 // condition
487: CP 14 889 // $slot.score.3
488: CP 15 894 // $slot.score.8
489: NAND 14 15 // nand
490: NAND 14 14 // and
491: CP 15 894 // $slot.score.8
492: CP 16 15 // sub
493: NAND 16 16 // ~
494: ADDi 16 1 // -src
495: ADD 14 16 // a-b
496: CPi 18 508 // condition (P)
497: BZJ 18 14 // condition
498: CP 14 890 // $slot.score.4
499: CP 15 893 // $slot.score.7
500: CP 16 15 // sub
501: NAND 16 16 // ~
502: ADDi 16 1 // -src
503: ADD 14 16 // a-b
504: CPi 18 508 // condition fallthrough (P)
505: BZJ 18 14 // condition fallthrough
506: CPi 18 510 // condition (P)
507: BZJi 18 0 // condition
508: CPi 18 552 // continue (P)
509: BZJi 18 0 // continue
510: CP 14 886 // $slot.score.0
511: CPi 18 880 // $slot.BCD_compare_digit.0
512: CPIi 18 14 // st param
513: CP 14 887 // $slot.score.1
514: CPi 18 881 // $slot.BCD_compare_digit.1
515: CPIi 18 14 // st param
516: CP 14 890 // $slot.score.4
517: CPi 18 882 // $slot.BCD_compare_digit.2
518: CPIi 18 14 // st param
519: CP 14 893 // $slot.score.7
520: CPi 18 883 // $slot.BCD_compare_digit.3
521: CPIi 18 14 // st param
522: CPi 18 870 // $RA.BCD_compare_digit
523: CPi 15 527 // retPC
524: CPIi 18 15 // st RA
525: CPi 18 149 // BCD_compare_digit
526: BZJi 18 0 // BCD_compare_digit
527: CP 891 14 // direct store
528: CP 14 891 // $slot.score.5
529: CPi 18 552 // condition (P)
530: BZJ 18 14 // condition
531: ADDi 867 1 // direct ++
532: CP 14 888 // $slot.score.2
533: CP 15 892 // $slot.score.6
534: CP 16 14 // or
535: NAND 16 16 // ~a
536: CP 17 15
537: NAND 17 17 // ~b
538: NAND 16 17 // a|b
539: CP 14 16
540: CP 888 14 // direct store
541: CP 14 889 // $slot.score.3
542: CP 15 894 // $slot.score.8
543: CP 16 14 // or
544: NAND 16 16 // ~a
545: CP 17 15
546: NAND 17 17 // ~b
547: NAND 16 17 // a|b
548: CP 14 16
549: CP 889 14 // direct store
550: CPi 18 555 // break (P)
551: BZJi 18 0 // break
552: ADDi 893 1 // direct ++
553: CPi 18 425 // for
554: BZJi 18 0 // loop
555: ADDi 890 1 // direct ++
556: CPi 18 413 // for
557: BZJi 18 0 // loop
558: CP 14 3 // ret 0
559: CPi 18 871 // $RA.score
560: CPI 15 18 // load RA
561: BZJi 15 0 // return
562: CPi 896 0 // init local
563: CPi 897 0 // init local
564: CPi 898 0 // init local
565: CPi 899 0 // init local
566: CPi 900 0 // init local
567: CPi 901 8192 // init local
568: CPi 902 2 // init local
569: CPi 903 0 // init local
570: CPi 904 1911 // init local
571: CP 14 904 // $slot.main.8
572: SRLi 14 36 // <<
573: CPi 15 7 // constant operand
574: CP 16 14 // or
575: NAND 16 16 // ~a
576: CP 17 15
577: NAND 17 17 // ~b
578: NAND 16 17 // a|b
579: CP 14 16
580: CP 904 14 // direct store
581: CP 14 901 // $slot.main.5
582: CPi 15 12 // constant operand
583: ADD 14 15 // +
584: CP 18 14
585: CPI 14 18 // deref
586: CP 15 902 // $slot.main.6
587: CP 16 15 // sub
588: NAND 16 16 // ~
589: ADDi 16 1 // -src
590: ADD 14 16 // a-b
591: CPi 18 613 // condition (P)
592: BZJ 18 14 // condition
593: CP 14 901 // $slot.main.5
594: CPi 15 12 // constant operand
595: ADD 14 15 // +
596: CP 18 14
597: CPI 14 18 // deref
598: CP 15 5 // constant operand
599: CP 16 15 // sub
600: NAND 16 16 // ~
601: ADDi 16 1 // -src
602: ADD 14 16 // a-b
603: CPi 18 607 // condition fallthrough (P)
604: BZJ 18 14 // condition fallthrough
605: CPi 18 611 // condition (P)
606: BZJi 18 0 // condition
607: CP 14 3 // constant
608: CPi 18 872 // $RA.main
609: CPI 15 18 // load RA
610: BZJi 15 0 // return
611: CPi 18 581 // wh loop
612: BZJi 18 0 // loop
613: CP 14 901 // $slot.main.5
614: CP 18 14
615: CPI 14 18 // deref
616: CP 895 14 // spill val
617: CP 14 3 // constant
618: CPi 18 905 // $slot.main.9
619: ADD 18 14 // +idx
620: CP 14 895 // reload val
621: CPIi 18 14 // []=
622: CP 14 901 // $slot.main.5
623: CP 15 4 // constant operand
624: ADD 14 15 // +
625: CP 18 14
626: CPI 14 18 // deref
627: CP 895 14 // spill val
628: CP 14 4 // constant
629: CPi 18 905 // $slot.main.9
630: ADD 18 14 // +idx
631: CP 14 895 // reload val
632: CPIi 18 14 // []=
633: CP 14 897 // $slot.main.1
634: CP 15 3 // constant operand
635: CP 16 15 // sub
636: NAND 16 16 // ~
637: ADDi 16 1 // -src
638: ADD 14 16 // a-b
639: CPi 18 643 // condition fallthrough (P)
640: BZJ 18 14 // condition fallthrough
641: CPi 18 857 // condition (P)
642: BZJi 18 0 // condition
643: CPi 896 0 // direct assignment
644: CP 14 896 // $slot.main.0
645: CP 15 4 // constant operand
646: CP 16 15 // sub
647: NAND 16 16 // ~
648: ADDi 16 1 // -src
649: ADD 14 16 // a-b
650: CPi 18 774 // condition (P)
651: BZJ 18 14 // condition
652: CP 14 897 // $slot.main.1
653: CP 15 4 // constant operand
654: CP 16 15 // sub
655: NAND 16 16 // ~
656: ADDi 16 1 // -src
657: ADD 14 16 // a-b
658: CPi 18 774 // condition (P)
659: BZJ 18 14 // condition
660: CP 14 903 // $slot.main.7
661: CP 15 902 // $slot.main.6
662: CPi 19 8 // sign bias
663: SRLi 19 60 // 2^31
664: ADD 14 19 // signed lhs bias
665: ADD 15 19 // signed rhs bias
666: LT 14 15 // <
667: CPi 18 772 // condition (P)
668: BZJ 18 14 // condition
669: CP 14 868 // AG_candidate
670: CP 15 904 // $slot.main.8
671: CP 16 15 // sub
672: NAND 16 16 // ~
673: ADDi 16 1 // -src
674: ADD 14 16 // a-b
675: CPi 18 679 // condition fallthrough (P)
676: BZJ 18 14 // condition fallthrough
677: CPi 18 682 // condition (P)
678: BZJi 18 0 // condition
679: CPi 897 1 // direct assignment
680: CPi 18 772 // break (P)
681: BZJi 18 0 // break
682: CP 14 903 // $slot.main.7
683: CPi 18 905 // $slot.main.9
684: ADD 18 14 // +idx
685: CPI 14 18 // ld[]
686: CP 16 14 // shift sign
687: SRLi 16 31 // negative?
688: CPi 18 695 // nonnegative shift (P)
689: BZJ 18 16 // nonnegative shift
690: NAND 14 14 // ~negative
691: SRLi 14 20 // >>
692: NAND 14 14 // sign extension
693: CPi 18 696 // shift end (P)
694: BZJi 18 0 // shift end
695: SRLi 14 20 // >>
696: CP 898 14 // direct store
697: CP 14 903 // $slot.main.7
698: CPi 18 905 // $slot.main.9
699: ADD 18 14 // +idx
700: CPI 14 18 // ld[]
701: CP 16 14 // shift sign
702: SRLi 16 31 // negative?
703: CPi 18 710 // nonnegative shift (P)
704: BZJ 18 16 // nonnegative shift
705: NAND 14 14 // ~negative
706: SRLi 14 16 // >>
707: NAND 14 14 // sign extension
708: CPi 18 711 // shift end (P)
709: BZJi 18 0 // shift end
710: SRLi 14 16 // >>
711: CPi 15 15 // constant operand
712: NAND 14 15 // nand
713: NAND 14 14 // and
714: CP 899 14 // direct store
715: CP 14 903 // $slot.main.7
716: CPi 18 905 // $slot.main.9
717: ADD 18 14 // +idx
718: CPI 14 18 // ld[]
719: CPi 15 3 // constant operand
720: SRLi 15 46 // <<14
721: ADDi 15 16383 // low
722: NAND 14 15 // nand
723: NAND 14 14 // and
724: CP 900 14 // direct store
725: CP 14 900 // $slot.main.4
726: CPi 18 886 // $slot.score.0
727: CPIi 18 14 // st param
728: CP 14 868 // AG_candidate
729: CPi 18 887 // $slot.score.1
730: CPIi 18 14 // st param
731: CPi 18 871 // $RA.score
732: CPi 15 736 // retPC
733: CPIi 18 15 // st RA
734: CPi 18 317 // score
735: BZJi 18 0 // score
736: CP 14 866 // plus
737: CP 15 898 // $slot.main.2
738: CP 16 15 // sub
739: NAND 16 16 // ~
740: ADDi 16 1 // -src
741: ADD 14 16 // a-b
742: CPi 18 746 // condition fallthrough (P)
743: BZJ 18 14 // condition fallthrough
744: CPi 18 763 // condition (P)
745: BZJi 18 0 // condition
746: CP 14 867 // minus
747: CP 15 899 // $slot.main.3
748: CP 16 15 // sub
749: NAND 16 16 // ~
750: ADDi 16 1 // -src
751: ADD 14 16 // a-b
752: CPi 18 756 // condition fallthrough (P)
753: BZJ 18 14 // condition fallthrough
754: CPi 18 763 // condition (P)
755: BZJi 18 0 // condition
756: CPi 896 1 // direct assignment
757: CP 14 903 // $slot.main.7
758: CP 15 4 // constant operand
759: ADD 14 15 // +
760: CP 903 14 // direct store
761: CPi 18 770 // if end (P)
762: BZJi 18 0 // if end
763: CPi 896 0 // direct assignment
764: CPi 18 869 // $RA.BCD_inc
765: CPi 15 769 // retPC
766: CPIi 18 15 // st RA
767: CPi 18 25 // BCD_inc
768: BZJi 18 0 // BCD_inc
769: CPi 903 0 // direct assignment
770: CPi 18 660 // wh loop
771: BZJi 18 0 // loop
772: CPi 18 644 // wh loop
773: BZJi 18 0 // loop
774: CP 14 868 // AG_candidate
775: CP 895 14 // spill val
776: CP 14 901 // $slot.main.5
777: CPi 15 25 // constant operand
778: ADD 14 15 // +
779: CP 18 14 // addr
780: CP 14 895 // reload val
781: CPIi 18 14 // *=
782: CP 14 896 // $slot.main.0
783: SRLi 14 33 // <<
784: CP 15 897 // $slot.main.1
785: CP 16 14 // or
786: NAND 16 16 // ~a
787: CP 17 15
788: NAND 17 17 // ~b
789: NAND 16 17 // a|b
790: CP 14 16
791: CP 895 14 // spill val
792: CP 14 901 // $slot.main.5
793: CPi 15 20 // constant operand
794: ADD 14 15 // +
795: CP 18 14 // addr
796: CP 14 895 // reload val
797: CPIi 18 14 // *=
798: CP 14 902 // $slot.main.6
799: CP 15 4 // constant operand
800: ADD 14 15 // +
801: CP 902 14 // direct store
802: CP 14 901 // $slot.main.5
803: CPi 15 12 // constant operand
804: ADD 14 15 // +
805: CP 18 14
806: CPI 14 18 // deref
807: CP 15 902 // $slot.main.6
808: CP 16 15 // sub
809: NAND 16 16 // ~
810: ADDi 16 1 // -src
811: ADD 14 16 // a-b
812: CPi 18 834 // condition (P)
813: BZJ 18 14 // condition
814: CP 14 901 // $slot.main.5
815: CPi 15 12 // constant operand
816: ADD 14 15 // +
817: CP 18 14
818: CPI 14 18 // deref
819: CP 15 5 // constant operand
820: CP 16 15 // sub
821: NAND 16 16 // ~
822: ADDi 16 1 // -src
823: ADD 14 16 // a-b
824: CPi 18 828 // condition fallthrough (P)
825: BZJ 18 14 // condition fallthrough
826: CPi 18 832 // condition (P)
827: BZJi 18 0 // condition
828: CP 14 3 // constant
829: CPi 18 872 // $RA.main
830: CPI 15 18 // load RA
831: BZJi 15 0 // return
832: CPi 18 802 // wh loop
833: BZJi 18 0 // loop
834: CP 14 901 // $slot.main.5
835: CP 15 902 // $slot.main.6
836: ADD 14 15 // +
837: CP 15 4 // constant operand
838: CP 16 15 // sub
839: NAND 16 16 // ~
840: ADDi 16 1 // -src
841: ADD 14 16 // a-b
842: CP 18 14
843: CPI 14 18 // deref
844: CP 895 14 // spill val
845: CP 14 902 // $slot.main.6
846: CP 15 4 // constant operand
847: CP 16 15 // sub
848: NAND 16 16 // ~
849: ADDi 16 1 // -src
850: ADD 14 16 // a-b
851: CPi 18 905 // $slot.main.9
852: ADD 18 14 // +idx
853: CP 14 895 // reload val
854: CPIi 18 14 // []=
855: CPi 18 633 // wh loop
856: BZJi 18 0 // loop
857: CP 14 3 // constant
858: CPi 18 872 // $RA.main
859: CPI 15 18 // load RA
860: BZJi 15 0 // return
861: CP 14 3 // ret 0
862: CPi 18 872 // $RA.main
863: CPI 15 18 // load RA
864: BZJi 15 0 // return
865: BZJi 3 865 // HALT
//$DATA_SECTION
866: 0 // g'plus'
867: 0 // g'minus'
868: 0 // g'AG_candidate'
869: 0 // g'$RA.BCD_inc'
870: 0 // g'$RA.BCD_compare_digit'
871: 0 // g'$RA.score'
872: 0 // g'$RA.main'
873: 0 // g'$spill.BCD_inc'[0]
874: 0 // g'$spill.BCD_inc'[1]
875: 0 // g'$slot.BCD_inc.0'
876: 0 // g'$slot.BCD_inc.1'
877: 0 // g'$slot.BCD_inc.2'
878: 0 // g'$spill.BCD_compare_digit'[0]
879: 0 // g'$spill.BCD_compare_digit'[1]
880: 0 // g'$slot.BCD_compare_digit.0'
881: 0 // g'$slot.BCD_compare_digit.1'
882: 0 // g'$slot.BCD_compare_digit.2'
883: 0 // g'$slot.BCD_compare_digit.3'
884: 0 // g'$slot.BCD_compare_digit.4'
885: 0 // g'$spill.score'
886: 0 // g'$slot.score.0'
887: 0 // g'$slot.score.1'
888: 0 // g'$slot.score.2'
889: 0 // g'$slot.score.3'
890: 0 // g'$slot.score.4'
891: 0 // g'$slot.score.5'
892: 0 // g'$slot.score.6'
893: 0 // g'$slot.score.7'
894: 0 // g'$slot.score.8'
895: 0 // g'$spill.main'
896: 0 // g'$slot.main.0'
897: 0 // g'$slot.main.1'
898: 0 // g'$slot.main.2'
899: 0 // g'$slot.main.3'
900: 0 // g'$slot.main.4'
901: 0 // g'$slot.main.5'
902: 0 // g'$slot.main.6'
903: 0 // g'$slot.main.7'
904: 0 // g'$slot.main.8'
905: 0 // g'$slot.main.9'[0]
906: 0 // g'$slot.main.9'[1]
907: 0 // g'$slot.main.9'[2]
908: 0 // g'$slot.main.9'[3]
909: 0 // g'$slot.main.9'[4]
910: 0 // g'$slot.main.9'[5]
911: 0 // g'$slot.main.9'[6]
912: 0 // g'$slot.main.9'[7]
913: 0 // g'$slot.main.9'[8]
914: 0 // g'$slot.main.9'[9]
//$STACK_SECTION // none (stackless calling convention)
