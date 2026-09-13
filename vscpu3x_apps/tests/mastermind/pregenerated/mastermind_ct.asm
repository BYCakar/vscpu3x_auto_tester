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
21: CPi 18 1323 // $RA.main addr
22: CPi 15 1317 // HALT addr
23: CPIi 18 15 // RA.main = HALT
24: BZJi 3 356 // Goto main
25: CP 14 1325 // $slot.BCD_compare_digit.0
26: CP 1324 14 // spill lhs
27: CP 14 1327 // $slot.BCD_compare_digit.2
28: CP 15 4 // constant operand
29: CP 16 15 // sub
30: NAND 16 16 // ~
31: ADDi 16 1 // -src
32: ADD 14 16 // a-b
33: CPi 15 4 // constant operand
34: MUL 14 15 // *
35: CP 15 14 // rhs
36: CP 14 1324 // reload lhs
37: CP 16 15 // shift amount
38: LTi 16 32 // amount<32?
39: CPi 18 53 // shift>=32 (P)
40: BZJ 18 16 // shift>=32
41: CP 16 14 // shift sign
42: SRLi 16 31 // negative?
43: CPi 18 50 // nonnegative shift (P)
44: BZJ 18 16 // nonnegative shift
45: NAND 14 14 // ~negative
46: SRL 14 15 // >>
47: NAND 14 14 // sign extension
48: CPi 18 51 // shift end (P)
49: BZJi 18 0 // shift end
50: SRL 14 15 // >>
51: CPi 18 54 // shift end (P)
52: BZJi 18 0 // shift end
53: CPi 14 0 // shift>=32
54: CP 1325 14 // direct store
55: CP 14 1325 // $slot.BCD_compare_digit.0
56: CPi 15 15 // constant operand
57: NAND 14 15 // nand
58: NAND 14 14 // and
59: CP 1325 14 // direct store
60: CP 14 1326 // $slot.BCD_compare_digit.1
61: CP 1324 14 // spill lhs
62: CP 14 1328 // $slot.BCD_compare_digit.3
63: CP 15 4 // constant operand
64: CP 16 15 // sub
65: NAND 16 16 // ~
66: ADDi 16 1 // -src
67: ADD 14 16 // a-b
68: CPi 15 4 // constant operand
69: MUL 14 15 // *
70: CP 15 14 // rhs
71: CP 14 1324 // reload lhs
72: CP 16 15 // shift amount
73: LTi 16 32 // amount<32?
74: CPi 18 88 // shift>=32 (P)
75: BZJ 18 16 // shift>=32
76: CP 16 14 // shift sign
77: SRLi 16 31 // negative?
78: CPi 18 85 // nonnegative shift (P)
79: BZJ 18 16 // nonnegative shift
80: NAND 14 14 // ~negative
81: SRL 14 15 // >>
82: NAND 14 14 // sign extension
83: CPi 18 86 // shift end (P)
84: BZJi 18 0 // shift end
85: SRL 14 15 // >>
86: CPi 18 89 // shift end (P)
87: BZJi 18 0 // shift end
88: CPi 14 0 // shift>=32
89: CP 1326 14 // direct store
90: CP 14 1326 // $slot.BCD_compare_digit.1
91: CPi 15 15 // constant operand
92: NAND 14 15 // nand
93: NAND 14 14 // and
94: CP 1326 14 // direct store
95: CP 14 1326 // $slot.BCD_compare_digit.1
96: CP 15 1325 // $slot.BCD_compare_digit.0
97: CP 16 15 // sub
98: NAND 16 16 // ~
99: ADDi 16 1 // -src
100: ADD 14 16 // a-b
101: LTi 14 1 // !
102: CPi 18 114 // && false (P)
103: BZJ 18 14 // && false
104: CP 14 1326 // $slot.BCD_compare_digit.1
105: CPi 15 15 // constant operand
106: CP 16 15 // sub
107: NAND 16 16 // ~
108: ADDi 16 1 // -src
109: ADD 14 16 // a-b
110: LTi 14 1 // !
111: LTi 14 1 // !
112: LTi 14 1 // !
113: LTi 14 1 // !
114: CPi 18 1321 // $RA.BCD_compare_digit
115: CPI 15 18 // load RA
116: BZJi 15 0 // return
117: CP 14 3 // ret 0
118: CPi 18 1321 // $RA.BCD_compare_digit
119: CPI 15 18 // load RA
120: BZJi 15 0 // return
121: CPi 1333 1 // direct assignment
122: CP 14 1333 // $slot.score.2
123: CPi 15 4 // constant operand
124: CPi 19 8 // sign bias
125: SRLi 19 60 // 2^31
126: ADD 14 19 // signed lhs bias
127: ADD 15 19 // signed rhs bias
128: LT 15 14 // b<a
129: CP 14 15
130: LTi 14 1 // !
131: CPi 18 226 // condition (P)
132: BZJ 18 14 // condition
133: CP 14 1331 // $slot.score.0
134: CPi 18 1325 // $slot.BCD_compare_digit.0
135: CPIi 18 14 // st param
136: CP 14 1332 // $slot.score.1
137: CPi 18 1326 // $slot.BCD_compare_digit.1
138: CPIi 18 14 // st param
139: CP 14 1333 // $slot.score.2
140: CPi 18 1327 // $slot.BCD_compare_digit.2
141: CPIi 18 14 // st param
142: CP 14 1333 // $slot.score.2
143: CPi 18 1328 // $slot.BCD_compare_digit.3
144: CPIi 18 14 // st param
145: CPi 18 1321 // $RA.BCD_compare_digit
146: CPi 15 150 // retPC
147: CPIi 18 15 // st RA
148: CPi 18 25 // BCD_compare_digit
149: BZJi 18 0 // BCD_compare_digit
150: CP 1334 14 // direct store
151: CP 14 1331 // $slot.score.0
152: CP 1329 14 // spill lhs
153: CPi 14 15 // constant
154: CP 15 1334 // $slot.score.3
155: MUL 14 15 // *
156: CP 1330 14 // spill lhs
157: CP 14 1333 // $slot.score.2
158: CP 15 4 // constant operand
159: CP 16 15 // sub
160: NAND 16 16 // ~
161: ADDi 16 1 // -src
162: ADD 14 16 // a-b
163: CPi 15 4 // constant operand
164: MUL 14 15 // *
165: CP 15 14 // rhs
166: CP 14 1330 // reload lhs
167: CP 16 15 // shift amount
168: LTi 16 32 // amount<32?
169: CPi 18 175 // shift>=32 (P)
170: BZJ 18 16 // shift>=32
171: ADDi 15 32 // left shift encoding
172: SRL 14 15 // <<
173: CPi 18 176 // shift end (P)
174: BZJi 18 0 // shift end
175: CPi 14 0 // shift>=32
176: CP 15 14 // rhs
177: CP 14 1329 // reload lhs
178: CP 16 14 // or
179: NAND 16 16 // ~a
180: CP 17 15
181: NAND 17 17 // ~b
182: NAND 16 17 // a|b
183: CP 14 16
184: CP 1331 14 // direct store
185: CP 14 1332 // $slot.score.1
186: CP 1329 14 // spill lhs
187: CPi 14 15 // constant
188: CP 15 1334 // $slot.score.3
189: MUL 14 15 // *
190: CP 1330 14 // spill lhs
191: CP 14 1333 // $slot.score.2
192: CP 15 4 // constant operand
193: CP 16 15 // sub
194: NAND 16 16 // ~
195: ADDi 16 1 // -src
196: ADD 14 16 // a-b
197: CPi 15 4 // constant operand
198: MUL 14 15 // *
199: CP 15 14 // rhs
200: CP 14 1330 // reload lhs
201: CP 16 15 // shift amount
202: LTi 16 32 // amount<32?
203: CPi 18 209 // shift>=32 (P)
204: BZJ 18 16 // shift>=32
205: ADDi 15 32 // left shift encoding
206: SRL 14 15 // <<
207: CPi 18 210 // shift end (P)
208: BZJi 18 0 // shift end
209: CPi 14 0 // shift>=32
210: CP 15 14 // rhs
211: CP 14 1329 // reload lhs
212: CP 16 14 // or
213: NAND 16 16 // ~a
214: CP 17 15
215: NAND 17 17 // ~b
216: NAND 16 17 // a|b
217: CP 14 16
218: CP 1332 14 // direct store
219: CP 14 1318 // g_plus
220: CP 15 1334 // $slot.score.3
221: ADD 14 15 // +
222: CP 1318 14 // direct store
223: ADDi 1333 1 // direct ++
224: CPi 18 122 // for
225: BZJi 18 0 // loop
226: CPi 1333 1 // direct assignment
227: CP 14 1333 // $slot.score.2
228: CPi 15 4 // constant operand
229: CPi 19 8 // sign bias
230: SRLi 19 60 // 2^31
231: ADD 14 19 // signed lhs bias
232: ADD 15 19 // signed rhs bias
233: LT 15 14 // b<a
234: CP 14 15
235: LTi 14 1 // !
236: CPi 18 352 // condition (P)
237: BZJ 18 14 // condition
238: CPi 1335 1 // direct assignment
239: CP 14 1335 // $slot.score.4
240: CPi 15 4 // constant operand
241: CPi 19 8 // sign bias
242: SRLi 19 60 // 2^31
243: ADD 14 19 // signed lhs bias
244: ADD 15 19 // signed rhs bias
245: LT 15 14 // b<a
246: CP 14 15
247: LTi 14 1 // !
248: CPi 18 349 // condition (P)
249: BZJ 18 14 // condition
250: CP 14 1333 // $slot.score.2
251: CP 15 1335 // $slot.score.4
252: CP 16 15 // sub
253: NAND 16 16 // ~
254: ADDi 16 1 // -src
255: ADD 14 16 // a-b
256: CPi 18 346 // condition (P)
257: BZJ 18 14 // condition
258: CP 14 1331 // $slot.score.0
259: CPi 18 1325 // $slot.BCD_compare_digit.0
260: CPIi 18 14 // st param
261: CP 14 1332 // $slot.score.1
262: CPi 18 1326 // $slot.BCD_compare_digit.1
263: CPIi 18 14 // st param
264: CP 14 1333 // $slot.score.2
265: CPi 18 1327 // $slot.BCD_compare_digit.2
266: CPIi 18 14 // st param
267: CP 14 1335 // $slot.score.4
268: CPi 18 1328 // $slot.BCD_compare_digit.3
269: CPIi 18 14 // st param
270: CPi 18 1321 // $RA.BCD_compare_digit
271: CPi 15 275 // retPC
272: CPIi 18 15 // st RA
273: CPi 18 25 // BCD_compare_digit
274: BZJi 18 0 // BCD_compare_digit
275: CP 1334 14 // direct store
276: CP 14 1334 // $slot.score.3
277: CPi 18 346 // condition (P)
278: BZJ 18 14 // condition
279: CP 14 1331 // $slot.score.0
280: CP 1329 14 // spill lhs
281: CPi 14 15 // constant
282: CP 1330 14 // spill lhs
283: CP 14 1333 // $slot.score.2
284: CP 15 4 // constant operand
285: CP 16 15 // sub
286: NAND 16 16 // ~
287: ADDi 16 1 // -src
288: ADD 14 16 // a-b
289: CPi 15 4 // constant operand
290: MUL 14 15 // *
291: CP 15 14 // rhs
292: CP 14 1330 // reload lhs
293: CP 16 15 // shift amount
294: LTi 16 32 // amount<32?
295: CPi 18 301 // shift>=32 (P)
296: BZJ 18 16 // shift>=32
297: ADDi 15 32 // left shift encoding
298: SRL 14 15 // <<
299: CPi 18 302 // shift end (P)
300: BZJi 18 0 // shift end
301: CPi 14 0 // shift>=32
302: CP 15 14 // rhs
303: CP 14 1329 // reload lhs
304: CP 16 14 // or
305: NAND 16 16 // ~a
306: CP 17 15
307: NAND 17 17 // ~b
308: NAND 16 17 // a|b
309: CP 14 16
310: CP 1331 14 // direct store
311: CP 14 1332 // $slot.score.1
312: CP 1329 14 // spill lhs
313: CPi 14 15 // constant
314: CP 1330 14 // spill lhs
315: CP 14 1335 // $slot.score.4
316: CP 15 4 // constant operand
317: CP 16 15 // sub
318: NAND 16 16 // ~
319: ADDi 16 1 // -src
320: ADD 14 16 // a-b
321: CPi 15 4 // constant operand
322: MUL 14 15 // *
323: CP 15 14 // rhs
324: CP 14 1330 // reload lhs
325: CP 16 15 // shift amount
326: LTi 16 32 // amount<32?
327: CPi 18 333 // shift>=32 (P)
328: BZJ 18 16 // shift>=32
329: ADDi 15 32 // left shift encoding
330: SRL 14 15 // <<
331: CPi 18 334 // shift end (P)
332: BZJi 18 0 // shift end
333: CPi 14 0 // shift>=32
334: CP 15 14 // rhs
335: CP 14 1329 // reload lhs
336: CP 16 14 // or
337: NAND 16 16 // ~a
338: CP 17 15
339: NAND 17 17 // ~b
340: NAND 16 17 // a|b
341: CP 14 16
342: CP 1332 14 // direct store
343: ADDi 1319 1 // direct ++
344: CPi 18 349 // break (P)
345: BZJi 18 0 // break
346: ADDi 1335 1 // direct ++
347: CPi 18 239 // for
348: BZJi 18 0 // loop
349: ADDi 1333 1 // direct ++
350: CPi 18 227 // for
351: BZJi 18 0 // loop
352: CP 14 3 // ret 0
353: CPi 18 1322 // $RA.score
354: CPI 15 18 // load RA
355: BZJi 15 0 // return
356: CPi 1338 0 // init local
357: CPi 1339 8192 // init local
358: CPi 1340 1 // init local
359: CPi 1340 0 // init local
360: CPi 1341 0 // init local
361: CP 14 1339 // $slot.main.1
362: CPi 15 11 // constant operand
363: ADD 14 15 // +
364: CP 18 14
365: CPI 14 18 // deref
366: CP 15 4 // constant operand
367: CP 16 15 // sub
368: NAND 16 16 // ~
369: ADDi 16 1 // -src
370: ADD 14 16 // a-b
371: CPi 18 375 // condition (P)
372: BZJ 18 14 // condition
373: CPi 18 361 // wh loop
374: BZJi 18 0 // loop
375: CPi 14 4660 // constant
376: CP 1336 14 // spill val
377: CP 14 1339 // $slot.main.1
378: CPi 15 10 // constant operand
379: ADD 14 15 // +
380: CP 18 14 // addr
381: CP 14 1336 // reload val
382: CPIi 18 14 // *=
383: CPi 14 2 // constant
384: CP 1336 14 // spill val
385: CP 14 1339 // $slot.main.1
386: CPi 15 11 // constant operand
387: ADD 14 15 // +
388: CP 18 14 // addr
389: CP 14 1336 // reload val
390: CPIi 18 14 // *=
391: CP 14 1339 // $slot.main.1
392: CPi 15 11 // constant operand
393: ADD 14 15 // +
394: CP 18 14
395: CPI 14 18 // deref
396: CP 15 4 // constant operand
397: CP 16 15 // sub
398: NAND 16 16 // ~
399: ADDi 16 1 // -src
400: ADD 14 16 // a-b
401: CPi 18 405 // condition (P)
402: BZJ 18 14 // condition
403: CPi 18 391 // wh loop
404: BZJi 18 0 // loop
405: CP 14 1339 // $slot.main.1
406: CPi 15 10 // constant operand
407: ADD 14 15 // +
408: CP 18 14
409: CPI 14 18 // deref
410: CP 1336 14 // spill val
411: CP 14 3 // constant
412: CPi 18 1342 // $slot.main.4
413: ADD 18 14 // +idx
414: CP 14 1336 // reload val
415: CPIi 18 14 // []=
416: CP 14 3 // constant
417: CPi 18 1342 // $slot.main.4
418: ADD 18 14 // +idx
419: CPI 14 18 // ld[]
420: CP 16 14 // shift sign
421: SRLi 16 31 // negative?
422: CPi 18 429 // nonnegative shift (P)
423: BZJ 18 16 // nonnegative shift
424: NAND 14 14 // ~negative
425: SRLi 14 20 // >>
426: NAND 14 14 // sign extension
427: CPi 18 430 // shift end (P)
428: BZJi 18 0 // shift end
429: SRLi 14 20 // >>
430: CPi 15 4 // constant operand
431: CP 16 15 // sub
432: NAND 16 16 // ~
433: ADDi 16 1 // -src
434: ADD 14 16 // a-b
435: CPi 18 439 // condition fallthrough (P)
436: BZJ 18 14 // condition fallthrough
437: CPi 18 451 // condition (P)
438: BZJi 18 0 // condition
439: CP 14 5 // constant
440: CP 1336 14 // spill val
441: CP 14 1339 // $slot.main.1
442: CPi 15 12 // constant operand
443: ADD 14 15 // +
444: CP 18 14 // addr
445: CP 14 1336 // reload val
446: CPIi 18 14 // *=
447: CP 14 3 // constant
448: CPi 18 1323 // $RA.main
449: CPI 15 18 // load RA
450: BZJi 15 0 // return
451: CPi 1338 1383 // direct assignment
452: CP 14 1338 // $slot.main.0
453: SRLi 14 36 // <<
454: CP 1338 14 // direct store
455: CP 14 1338 // $slot.main.0
456: CP 1336 14 // spill val
457: CP 14 1339 // $slot.main.1
458: CPi 15 10 // constant operand
459: ADD 14 15 // +
460: CP 18 14 // addr
461: CP 14 1336 // reload val
462: CPIi 18 14 // *=
463: CPi 14 2 // constant
464: CP 1336 14 // spill val
465: CP 14 1339 // $slot.main.1
466: CPi 15 11 // constant operand
467: ADD 14 15 // +
468: CP 18 14 // addr
469: CP 14 1336 // reload val
470: CPIi 18 14 // *=
471: CP 14 1339 // $slot.main.1
472: CPi 15 11 // constant operand
473: ADD 14 15 // +
474: CP 18 14
475: CPI 14 18 // deref
476: CP 15 4 // constant operand
477: CP 16 15 // sub
478: NAND 16 16 // ~
479: ADDi 16 1 // -src
480: ADD 14 16 // a-b
481: CPi 18 485 // condition (P)
482: BZJ 18 14 // condition
483: CPi 18 471 // wh loop
484: BZJi 18 0 // loop
485: CP 14 1339 // $slot.main.1
486: CPi 15 10 // constant operand
487: ADD 14 15 // +
488: CP 18 14
489: CPI 14 18 // deref
490: CP 1336 14 // spill val
491: CP 14 4 // constant
492: CPi 18 1342 // $slot.main.4
493: ADD 18 14 // +idx
494: CP 14 1336 // reload val
495: CPIi 18 14 // []=
496: CP 14 4 // constant
497: CPi 18 1342 // $slot.main.4
498: ADD 18 14 // +idx
499: CPI 14 18 // ld[]
500: CP 16 14 // shift sign
501: SRLi 16 31 // negative?
502: CPi 18 509 // nonnegative shift (P)
503: BZJ 18 16 // nonnegative shift
504: NAND 14 14 // ~negative
505: SRLi 14 20 // >>
506: NAND 14 14 // sign extension
507: CPi 18 510 // shift end (P)
508: BZJi 18 0 // shift end
509: SRLi 14 20 // >>
510: CPi 15 4 // constant operand
511: CP 16 15 // sub
512: NAND 16 16 // ~
513: ADDi 16 1 // -src
514: ADD 14 16 // a-b
515: CPi 18 519 // condition fallthrough (P)
516: BZJ 18 14 // condition fallthrough
517: CPi 18 531 // condition (P)
518: BZJi 18 0 // condition
519: CP 14 5 // constant
520: CP 1336 14 // spill val
521: CP 14 1339 // $slot.main.1
522: CPi 15 12 // constant operand
523: ADD 14 15 // +
524: CP 18 14 // addr
525: CP 14 1336 // reload val
526: CPIi 18 14 // *=
527: CP 14 3 // constant
528: CPi 18 1323 // $RA.main
529: CPI 15 18 // load RA
530: BZJi 15 0 // return
531: CP 14 3 // constant
532: CPi 18 1342 // $slot.main.4
533: ADD 18 14 // +idx
534: CPI 14 18 // ld[]
535: CP 1336 14 // spill val
536: CP 14 1339 // $slot.main.1
537: CP 18 14 // addr
538: CP 14 1336 // reload val
539: CPIi 18 14 // *=
540: CP 14 4 // constant
541: CPi 18 1342 // $slot.main.4
542: ADD 18 14 // +idx
543: CPI 14 18 // ld[]
544: CP 1336 14 // spill val
545: CP 14 1339 // $slot.main.1
546: CP 15 4 // constant operand
547: ADD 14 15 // +
548: CP 18 14 // addr
549: CP 14 1336 // reload val
550: CPIi 18 14 // *=
551: CPi 1340 2 // direct assignment
552: CPi 1352 0 // init local
553: CPi 1374 0 // direct assignment
554: CP 14 1374 // $slot.main.11
555: CP 15 1320 // AG_count
556: CPi 19 8 // sign bias
557: SRLi 19 60 // 2^31
558: ADD 14 19 // signed lhs bias
559: ADD 15 19 // signed rhs bias
560: LT 14 15 // <
561: CPi 18 576 // condition (P)
562: BZJ 18 14 // condition
563: CP 14 1340 // $slot.main.2
564: CP 1336 14 // spill val
565: CP 14 1339 // $slot.main.1
566: CPi 15 12 // constant operand
567: ADD 14 15 // +
568: CP 15 1374 // $slot.main.11
569: ADD 14 15 // +
570: CP 18 14 // addr
571: CP 14 1336 // reload val
572: CPIi 18 14 // *=
573: ADDi 1374 1 // direct ++
574: CPi 18 554 // for
575: BZJi 18 0 // loop
576: CPi 1374 0 // direct assignment
577: CP 14 1374 // $slot.main.11
578: CP 15 1320 // AG_count
579: CPi 19 8 // sign bias
580: SRLi 19 60 // 2^31
581: ADD 14 19 // signed lhs bias
582: ADD 15 19 // signed rhs bias
583: LT 14 15 // <
584: CPi 18 676 // condition (P)
585: BZJ 18 14 // condition
586: CP 14 1339 // $slot.main.1
587: CPi 15 20 // constant operand
588: ADD 14 15 // +
589: CP 15 1374 // $slot.main.11
590: ADD 14 15 // +
591: CP 18 14
592: CPI 14 18 // deref
593: CP 15 3 // constant operand
594: CP 16 15 // sub
595: NAND 16 16 // ~
596: ADDi 16 1 // -src
597: ADD 14 16 // a-b
598: CPi 18 602 // condition fallthrough (P)
599: BZJ 18 14 // condition fallthrough
600: CPi 18 604 // condition (P)
601: BZJi 18 0 // condition
602: CPi 18 586 // wh loop
603: BZJi 18 0 // loop
604: CP 14 1339 // $slot.main.1
605: CPi 15 20 // constant operand
606: ADD 14 15 // +
607: CP 15 1374 // $slot.main.11
608: ADD 14 15 // +
609: CP 18 14
610: CPI 14 18 // deref
611: CP 1336 14 // spill val
612: CP 14 1374 // $slot.main.11
613: CPi 18 1358 // $slot.main.7
614: ADD 18 14 // +idx
615: CP 14 1336 // reload val
616: CPIi 18 14 // []=
617: CP 14 1374 // $slot.main.11
618: CPi 18 1358 // $slot.main.7
619: ADD 18 14 // +idx
620: CPI 14 18 // ld[]
621: CP 15 4 // constant operand
622: NAND 14 15 // nand
623: NAND 14 14 // and
624: CP 1336 14 // spill val
625: CP 14 1374 // $slot.main.11
626: CPi 18 1353 // $slot.main.6
627: ADD 18 14 // +idx
628: CP 14 1336 // reload val
629: CPIi 18 14 // []=
630: CP 14 1374 // $slot.main.11
631: CPi 18 1358 // $slot.main.7
632: ADD 18 14 // +idx
633: CPI 14 18 // ld[]
634: CP 16 14 // shift sign
635: SRLi 16 31 // negative?
636: CPi 18 643 // nonnegative shift (P)
637: BZJ 18 16 // nonnegative shift
638: NAND 14 14 // ~negative
639: SRLi 14 1 // >>
640: NAND 14 14 // sign extension
641: CPi 18 644 // shift end (P)
642: BZJi 18 0 // shift end
643: SRLi 14 1 // >>
644: CP 1336 14 // spill val
645: CP 14 1374 // $slot.main.11
646: CPi 18 1358 // $slot.main.7
647: ADD 18 14 // +idx
648: CP 14 1336 // reload val
649: CPIi 18 14 // []=
650: CP 14 1374 // $slot.main.11
651: CPi 18 1353 // $slot.main.6
652: ADD 18 14 // +idx
653: CPI 14 18 // ld[]
654: CP 15 3 // constant operand
655: CP 16 15 // sub
656: NAND 16 16 // ~
657: ADDi 16 1 // -src
658: ADD 14 16 // a-b
659: CPi 18 663 // condition fallthrough (P)
660: BZJ 18 14 // condition fallthrough
661: CPi 18 673 // condition (P)
662: BZJi 18 0 // condition
663: CP 14 3 // constant
664: CP 1336 14 // spill val
665: CP 14 1339 // $slot.main.1
666: CPi 15 20 // constant operand
667: ADD 14 15 // +
668: CP 15 1374 // $slot.main.11
669: ADD 14 15 // +
670: CP 18 14 // addr
671: CP 14 1336 // reload val
672: CPIi 18 14 // *=
673: ADDi 1374 1 // direct ++
674: CPi 18 577 // for
675: BZJi 18 0 // loop
676: CPi 1374 0 // direct assignment
677: CP 14 1374 // $slot.main.11
678: CP 15 1320 // AG_count
679: CPi 19 8 // sign bias
680: SRLi 19 60 // 2^31
681: ADD 14 19 // signed lhs bias
682: ADD 15 19 // signed rhs bias
683: LT 14 15 // <
684: CPi 18 696 // condition (P)
685: BZJ 18 14 // condition
686: CP 14 3 // constant
687: CP 1336 14 // spill val
688: CP 14 1374 // $slot.main.11
689: CPi 18 1363 // $slot.main.8
690: ADD 18 14 // +idx
691: CP 14 1336 // reload val
692: CPIi 18 14 // []=
693: ADDi 1374 1 // direct ++
694: CPi 18 677 // for
695: BZJi 18 0 // loop
696: CPi 1374 0 // direct assignment
697: CP 14 1374 // $slot.main.11
698: CP 15 1320 // AG_count
699: CPi 19 8 // sign bias
700: SRLi 19 60 // 2^31
701: ADD 14 19 // signed lhs bias
702: ADD 15 19 // signed rhs bias
703: LT 14 15 // <
704: CPi 18 1054 // condition (P)
705: BZJ 18 14 // condition
706: CP 14 1374 // $slot.main.11
707: CPi 18 1358 // $slot.main.7
708: ADD 18 14 // +idx
709: CPI 14 18 // ld[]
710: CPi 18 1051 // condition (P)
711: BZJ 18 14 // condition
712: CP 14 1374 // $slot.main.11
713: CPi 18 1353 // $slot.main.6
714: ADD 18 14 // +idx
715: CPI 14 18 // ld[]
716: CP 15 3 // constant operand
717: CP 16 15 // sub
718: NAND 16 16 // ~
719: ADDi 16 1 // -src
720: ADD 14 16 // a-b
721: CPi 18 725 // condition fallthrough (P)
722: BZJ 18 14 // condition fallthrough
723: CPi 18 1051 // condition (P)
724: BZJi 18 0 // condition
725: CPi 1390 0 // direct assignment
726: CPi 1375 0 // direct assignment
727: CP 14 1375 // $slot.main.12
728: CPi 15 5 // constant operand
729: CPi 19 8 // sign bias
730: SRLi 19 60 // 2^31
731: ADD 14 19 // signed lhs bias
732: ADD 15 19 // signed rhs bias
733: LT 14 15 // <
734: CPi 18 746 // condition (P)
735: BZJ 18 14 // condition
736: CP 14 3 // constant
737: CP 1336 14 // spill val
738: CP 14 1375 // $slot.main.12
739: CPi 18 1376 // $slot.main.13
740: ADD 18 14 // +idx
741: CP 14 1336 // reload val
742: CPIi 18 14 // []=
743: ADDi 1375 1 // direct ++
744: CPi 18 727 // for
745: BZJi 18 0 // loop
746: CPi 1375 0 // direct assignment
747: CP 14 1375 // $slot.main.12
748: CPi 15 4 // constant operand
749: CPi 19 8 // sign bias
750: SRLi 19 60 // 2^31
751: ADD 14 19 // signed lhs bias
752: ADD 15 19 // signed rhs bias
753: LT 14 15 // <
754: CPi 18 766 // condition (P)
755: BZJ 18 14 // condition
756: CP 14 3 // constant
757: CP 1336 14 // spill val
758: CP 14 1375 // $slot.main.12
759: CPi 18 1381 // $slot.main.14
760: ADD 18 14 // +idx
761: CP 14 1336 // reload val
762: CPIi 18 14 // []=
763: ADDi 1375 1 // direct ++
764: CPi 18 747 // for
765: BZJi 18 0 // loop
766: CPi 1375 0 // direct assignment
767: CP 14 1375 // $slot.main.12
768: CPi 15 3 // constant operand
769: CPi 19 8 // sign bias
770: SRLi 19 60 // 2^31
771: ADD 14 19 // signed lhs bias
772: ADD 15 19 // signed rhs bias
773: LT 14 15 // <
774: CPi 18 786 // condition (P)
775: BZJ 18 14 // condition
776: CP 14 3 // constant
777: CP 1336 14 // spill val
778: CP 14 1375 // $slot.main.12
779: CPi 18 1385 // $slot.main.15
780: ADD 18 14 // +idx
781: CP 14 1336 // reload val
782: CPIi 18 14 // []=
783: ADDi 1375 1 // direct ++
784: CPi 18 767 // for
785: BZJi 18 0 // loop
786: CP 14 3 // constant
787: CP 1336 14 // spill val
788: CP 14 3 // constant
789: CPi 18 1388 // $slot.main.16
790: ADD 18 14 // +idx
791: CP 14 1336 // reload val
792: CPIi 18 14 // []=
793: CP 14 3 // constant
794: CP 1336 14 // spill val
795: CP 14 3 // constant
796: CPi 18 1389 // $slot.main.17
797: ADD 18 14 // +idx
798: CP 14 1336 // reload val
799: CPIi 18 14 // []=
800: CPi 1375 0 // direct assignment
801: CP 14 1375 // $slot.main.12
802: CP 15 1320 // AG_count
803: CPi 19 8 // sign bias
804: SRLi 19 60 // 2^31
805: ADD 14 19 // signed lhs bias
806: ADD 15 19 // signed rhs bias
807: LT 14 15 // <
808: CPi 18 954 // condition (P)
809: BZJ 18 14 // condition
810: CP 14 1375 // $slot.main.12
811: CPi 18 1353 // $slot.main.6
812: ADD 18 14 // +idx
813: CPI 14 18 // ld[]
814: CP 15 3 // constant operand
815: CP 16 15 // sub
816: NAND 16 16 // ~
817: ADDi 16 1 // -src
818: ADD 14 16 // a-b
819: CPi 18 823 // condition fallthrough (P)
820: BZJ 18 14 // condition fallthrough
821: CPi 18 951 // condition (P)
822: BZJi 18 0 // condition
823: CP 14 1375 // $slot.main.12
824: CP 15 1374 // $slot.main.11
825: CP 16 15 // sub
826: NAND 16 16 // ~
827: ADDi 16 1 // -src
828: ADD 14 16 // a-b
829: CPi 18 951 // condition (P)
830: BZJ 18 14 // condition
831: CP 14 1339 // $slot.main.1
832: CPi 15 25 // constant operand
833: ADD 14 15 // +
834: CP 15 1374 // $slot.main.11
835: ADD 14 15 // +
836: CP 18 14
837: CPI 14 18 // deref
838: CP 1336 14 // spill arg
839: CP 14 1339 // $slot.main.1
840: CPi 15 25 // constant operand
841: ADD 14 15 // +
842: CP 15 1375 // $slot.main.12
843: ADD 14 15 // +
844: CP 18 14
845: CPI 14 18 // deref
846: CP 1337 14 // spill arg
847: CP 14 1337 // reload arg
848: CPi 18 1332 // $slot.score.1
849: CPIi 18 14 // st param
850: CP 14 1336 // reload arg
851: CPi 18 1331 // $slot.score.0
852: CPIi 18 14 // st param
853: CPi 18 1322 // $RA.score
854: CPi 15 858 // retPC
855: CPIi 18 15 // st RA
856: CPi 18 121 // score
857: BZJi 18 0 // score
858: CP 14 1318 // g_plus
859: CP 15 3 // constant operand
860: CP 16 15 // sub
861: NAND 16 16 // ~
862: ADDi 16 1 // -src
863: ADD 14 16 // a-b
864: CPi 18 868 // condition fallthrough (P)
865: BZJ 18 14 // condition fallthrough
866: CPi 18 877 // condition (P)
867: BZJi 18 0 // condition
868: CP 14 4 // constant
869: CP 1336 14 // spill val
870: CP 14 1319 // g_minus
871: CPi 18 1376 // $slot.main.13
872: ADD 18 14 // +idx
873: CP 14 1336 // reload val
874: CPIi 18 14 // []=
875: CPi 18 951 // if end (P)
876: BZJi 18 0 // if end
877: CP 14 1318 // g_plus
878: CP 15 4 // constant operand
879: CP 16 15 // sub
880: NAND 16 16 // ~
881: ADDi 16 1 // -src
882: ADD 14 16 // a-b
883: CPi 18 887 // condition fallthrough (P)
884: BZJ 18 14 // condition fallthrough
885: CPi 18 896 // condition (P)
886: BZJi 18 0 // condition
887: CP 14 4 // constant
888: CP 1336 14 // spill val
889: CP 14 1319 // g_minus
890: CPi 18 1381 // $slot.main.14
891: ADD 18 14 // +idx
892: CP 14 1336 // reload val
893: CPIi 18 14 // []=
894: CPi 18 951 // if end (P)
895: BZJi 18 0 // if end
896: CP 14 1318 // g_plus
897: CPi 15 2 // constant operand
898: CP 16 15 // sub
899: NAND 16 16 // ~
900: ADDi 16 1 // -src
901: ADD 14 16 // a-b
902: CPi 18 906 // condition fallthrough (P)
903: BZJ 18 14 // condition fallthrough
904: CPi 18 915 // condition (P)
905: BZJi 18 0 // condition
906: CP 14 4 // constant
907: CP 1336 14 // spill val
908: CP 14 1319 // g_minus
909: CPi 18 1385 // $slot.main.15
910: ADD 18 14 // +idx
911: CP 14 1336 // reload val
912: CPIi 18 14 // []=
913: CPi 18 951 // if end (P)
914: BZJi 18 0 // if end
915: CP 14 1318 // g_plus
916: CPi 15 3 // constant operand
917: CP 16 15 // sub
918: NAND 16 16 // ~
919: ADDi 16 1 // -src
920: ADD 14 16 // a-b
921: CPi 18 925 // condition fallthrough (P)
922: BZJ 18 14 // condition fallthrough
923: CPi 18 934 // condition (P)
924: BZJi 18 0 // condition
925: CP 14 4 // constant
926: CP 1336 14 // spill val
927: CP 14 3 // constant
928: CPi 18 1388 // $slot.main.16
929: ADD 18 14 // +idx
930: CP 14 1336 // reload val
931: CPIi 18 14 // []=
932: CPi 18 951 // if end (P)
933: BZJi 18 0 // if end
934: CP 14 1318 // g_plus
935: CPi 15 4 // constant operand
936: CP 16 15 // sub
937: NAND 16 16 // ~
938: ADDi 16 1 // -src
939: ADD 14 16 // a-b
940: CPi 18 944 // condition fallthrough (P)
941: BZJ 18 14 // condition fallthrough
942: CPi 18 951 // condition (P)
943: BZJi 18 0 // condition
944: CP 14 4 // constant
945: CP 1336 14 // spill val
946: CP 14 3 // constant
947: CPi 18 1389 // $slot.main.17
948: ADD 18 14 // +idx
949: CP 14 1336 // reload val
950: CPIi 18 14 // []=
951: ADDi 1375 1 // direct ++
952: CPi 18 801 // for
953: BZJi 18 0 // loop
954: CPi 1390 0 // direct assignment
955: CPi 1375 0 // direct assignment
956: CP 14 1375 // $slot.main.12
957: CPi 15 5 // constant operand
958: CPi 19 8 // sign bias
959: SRLi 19 60 // 2^31
960: ADD 14 19 // signed lhs bias
961: ADD 15 19 // signed rhs bias
962: LT 14 15 // <
963: CPi 18 978 // condition (P)
964: BZJ 18 14 // condition
965: CP 14 1390 // $slot.main.18
966: CP 1336 14 // spill lhs
967: CP 14 1375 // $slot.main.12
968: CPi 18 1376 // $slot.main.13
969: ADD 18 14 // +idx
970: CPI 14 18 // ld[]
971: CP 15 14 // rhs
972: CP 14 1336 // reload lhs
973: ADD 14 15 // +
974: CP 1390 14 // direct store
975: ADDi 1375 1 // direct ++
976: CPi 18 956 // for
977: BZJi 18 0 // loop
978: CPi 1375 0 // direct assignment
979: CP 14 1375 // $slot.main.12
980: CPi 15 4 // constant operand
981: CPi 19 8 // sign bias
982: SRLi 19 60 // 2^31
983: ADD 14 19 // signed lhs bias
984: ADD 15 19 // signed rhs bias
985: LT 14 15 // <
986: CPi 18 1001 // condition (P)
987: BZJ 18 14 // condition
988: CP 14 1390 // $slot.main.18
989: CP 1336 14 // spill lhs
990: CP 14 1375 // $slot.main.12
991: CPi 18 1381 // $slot.main.14
992: ADD 18 14 // +idx
993: CPI 14 18 // ld[]
994: CP 15 14 // rhs
995: CP 14 1336 // reload lhs
996: ADD 14 15 // +
997: CP 1390 14 // direct store
998: ADDi 1375 1 // direct ++
999: CPi 18 979 // for
1000: BZJi 18 0 // loop
1001: CPi 1375 0 // direct assignment
1002: CP 14 1375 // $slot.main.12
1003: CPi 15 3 // constant operand
1004: CPi 19 8 // sign bias
1005: SRLi 19 60 // 2^31
1006: ADD 14 19 // signed lhs bias
1007: ADD 15 19 // signed rhs bias
1008: LT 14 15 // <
1009: CPi 18 1024 // condition (P)
1010: BZJ 18 14 // condition
1011: CP 14 1390 // $slot.main.18
1012: CP 1336 14 // spill lhs
1013: CP 14 1375 // $slot.main.12
1014: CPi 18 1385 // $slot.main.15
1015: ADD 18 14 // +idx
1016: CPI 14 18 // ld[]
1017: CP 15 14 // rhs
1018: CP 14 1336 // reload lhs
1019: ADD 14 15 // +
1020: CP 1390 14 // direct store
1021: ADDi 1375 1 // direct ++
1022: CPi 18 1002 // for
1023: BZJi 18 0 // loop
1024: CP 14 1390 // $slot.main.18
1025: CP 1336 14 // spill lhs
1026: CP 14 3 // constant
1027: CPi 18 1388 // $slot.main.16
1028: ADD 18 14 // +idx
1029: CPI 14 18 // ld[]
1030: CP 15 14 // rhs
1031: CP 14 1336 // reload lhs
1032: ADD 14 15 // +
1033: CP 1390 14 // direct store
1034: CP 14 1390 // $slot.main.18
1035: CP 1336 14 // spill lhs
1036: CP 14 3 // constant
1037: CPi 18 1389 // $slot.main.17
1038: ADD 18 14 // +idx
1039: CPI 14 18 // ld[]
1040: CP 15 14 // rhs
1041: CP 14 1336 // reload lhs
1042: ADD 14 15 // +
1043: CP 1390 14 // direct store
1044: CP 14 1390 // $slot.main.18
1045: CP 1336 14 // spill val
1046: CP 14 1374 // $slot.main.11
1047: CPi 18 1363 // $slot.main.8
1048: ADD 18 14 // +idx
1049: CP 14 1336 // reload val
1050: CPIi 18 14 // []=
1051: ADDi 1374 1 // direct ++
1052: CPi 18 697 // for
1053: BZJi 18 0 // loop
1054: CPi 1352 0 // direct assignment
1055: CPi 1375 0 // direct assignment
1056: CP 14 1375 // $slot.main.12
1057: CP 15 1320 // AG_count
1058: CPi 19 8 // sign bias
1059: SRLi 19 60 // 2^31
1060: ADD 14 19 // signed lhs bias
1061: ADD 15 19 // signed rhs bias
1062: LT 14 15 // <
1063: CPi 18 1097 // condition (P)
1064: BZJ 18 14 // condition
1065: CP 14 1352 // $slot.main.5
1066: CP 1336 14 // spill condition lhs
1067: CP 14 1375 // $slot.main.12
1068: CPi 18 1363 // $slot.main.8
1069: ADD 18 14 // +idx
1070: CPI 14 18 // ld[]
1071: CP 15 14 // condition rhs
1072: CP 14 1336 // reload condition lhs
1073: CPi 19 8 // sign bias
1074: SRLi 19 60 // 2^31
1075: ADD 14 19 // signed lhs bias
1076: ADD 15 19 // signed rhs bias
1077: LT 15 14 // b<a
1078: CP 14 15
1079: LTi 14 1 // !
1080: CPi 18 1094 // condition (P)
1081: BZJ 18 14 // condition
1082: CP 14 1375 // $slot.main.12
1083: CPi 18 1363 // $slot.main.8
1084: ADD 18 14 // +idx
1085: CPI 14 18 // ld[]
1086: CP 1352 14 // direct store
1087: CP 14 4 // constant
1088: CP 1336 14 // spill val
1089: CP 14 1375 // $slot.main.12
1090: CPi 18 1368 // $slot.main.9
1091: ADD 18 14 // +idx
1092: CP 14 1336 // reload val
1093: CPIi 18 14 // []=
1094: ADDi 1375 1 // direct ++
1095: CPi 18 1056 // for
1096: BZJi 18 0 // loop
1097: CPi 1375 0 // direct assignment
1098: CP 14 1375 // $slot.main.12
1099: CP 15 1320 // AG_count
1100: CPi 19 8 // sign bias
1101: SRLi 19 60 // 2^31
1102: ADD 14 19 // signed lhs bias
1103: ADD 15 19 // signed rhs bias
1104: LT 14 15 // <
1105: CPi 18 1129 // condition (P)
1106: BZJ 18 14 // condition
1107: CP 14 1375 // $slot.main.12
1108: CPi 18 1363 // $slot.main.8
1109: ADD 18 14 // +idx
1110: CPI 14 18 // ld[]
1111: CP 15 1352 // $slot.main.5
1112: CPi 19 8 // sign bias
1113: SRLi 19 60 // 2^31
1114: ADD 14 19 // signed lhs bias
1115: ADD 15 19 // signed rhs bias
1116: LT 14 15 // <
1117: CPi 18 1126 // condition (P)
1118: BZJ 18 14 // condition
1119: CP 14 3 // constant
1120: CP 1336 14 // spill val
1121: CP 14 1375 // $slot.main.12
1122: CPi 18 1368 // $slot.main.9
1123: ADD 18 14 // +idx
1124: CP 14 1336 // reload val
1125: CPIi 18 14 // []=
1126: ADDi 1375 1 // direct ++
1127: CPi 18 1098 // for
1128: BZJi 18 0 // loop
1129: CPi 1373 0 // direct assignment
1130: CP 14 1373 // $slot.main.10
1131: CP 15 3 // constant operand
1132: CP 16 15 // sub
1133: NAND 16 16 // ~
1134: ADDi 16 1 // -src
1135: ADD 14 16 // a-b
1136: CPi 18 1140 // condition fallthrough (P)
1137: BZJ 18 14 // condition fallthrough
1138: CPi 18 1173 // condition (P)
1139: BZJi 18 0 // condition
1140: CP 14 1341 // $slot.main.3
1141: CPi 18 1368 // $slot.main.9
1142: ADD 18 14 // +idx
1143: CPI 14 18 // ld[]
1144: CP 15 4 // constant operand
1145: CP 16 15 // sub
1146: NAND 16 16 // ~
1147: ADDi 16 1 // -src
1148: ADD 14 16 // a-b
1149: CPi 18 1153 // condition fallthrough (P)
1150: BZJ 18 14 // condition fallthrough
1151: CPi 18 1156 // condition (P)
1152: BZJi 18 0 // condition
1153: CPi 1373 1 // direct assignment
1154: CPi 18 1171 // if end (P)
1155: BZJi 18 0 // if end
1156: CP 14 1341 // $slot.main.3
1157: CP 15 4 // constant operand
1158: ADD 14 15 // +
1159: CP 1341 14 // direct store
1160: CP 14 1341 // $slot.main.3
1161: CP 15 1320 // AG_count
1162: CPi 19 8 // sign bias
1163: SRLi 19 60 // 2^31
1164: ADD 14 19 // signed lhs bias
1165: ADD 15 19 // signed rhs bias
1166: LT 14 15 // a<b
1167: LTi 14 1 // !
1168: CPi 18 1171 // condition (P)
1169: BZJ 18 14 // condition
1170: CPi 1341 0 // direct assignment
1171: CPi 18 1130 // wh loop
1172: BZJi 18 0 // loop
1173: CPi 1375 0 // direct assignment
1174: CP 14 1375 // $slot.main.12
1175: CP 15 1320 // AG_count
1176: CPi 19 8 // sign bias
1177: SRLi 19 60 // 2^31
1178: ADD 14 19 // signed lhs bias
1179: ADD 15 19 // signed rhs bias
1180: LT 14 15 // <
1181: CPi 18 1193 // condition (P)
1182: BZJ 18 14 // condition
1183: CP 14 3 // constant
1184: CP 1336 14 // spill val
1185: CP 14 1375 // $slot.main.12
1186: CPi 18 1368 // $slot.main.9
1187: ADD 18 14 // +idx
1188: CP 14 1336 // reload val
1189: CPIi 18 14 // []=
1190: ADDi 1375 1 // direct ++
1191: CPi 18 1174 // for
1192: BZJi 18 0 // loop
1193: CP 14 1339 // $slot.main.1
1194: CPi 15 25 // constant operand
1195: ADD 14 15 // +
1196: CP 15 1341 // $slot.main.3
1197: ADD 14 15 // +
1198: CP 18 14
1199: CPI 14 18 // deref
1200: CP 1338 14 // direct store
1201: CP 14 1341 // $slot.main.3
1202: CP 15 4 // constant operand
1203: ADD 14 15 // +
1204: CP 1341 14 // direct store
1205: CP 14 1341 // $slot.main.3
1206: CP 15 1320 // AG_count
1207: CPi 19 8 // sign bias
1208: SRLi 19 60 // 2^31
1209: ADD 14 19 // signed lhs bias
1210: ADD 15 19 // signed rhs bias
1211: LT 14 15 // a<b
1212: LTi 14 1 // !
1213: CPi 18 1216 // condition (P)
1214: BZJ 18 14 // condition
1215: CPi 1341 0 // direct assignment
1216: CP 14 1338 // $slot.main.0
1217: CP 1336 14 // spill val
1218: CP 14 1339 // $slot.main.1
1219: CPi 15 10 // constant operand
1220: ADD 14 15 // +
1221: CP 18 14 // addr
1222: CP 14 1336 // reload val
1223: CPIi 18 14 // *=
1224: CPi 14 2 // constant
1225: CP 1336 14 // spill val
1226: CP 14 1339 // $slot.main.1
1227: CPi 15 11 // constant operand
1228: ADD 14 15 // +
1229: CP 18 14 // addr
1230: CP 14 1336 // reload val
1231: CPIi 18 14 // *=
1232: CP 14 1339 // $slot.main.1
1233: CPi 15 11 // constant operand
1234: ADD 14 15 // +
1235: CP 18 14
1236: CPI 14 18 // deref
1237: CP 15 4 // constant operand
1238: CP 16 15 // sub
1239: NAND 16 16 // ~
1240: ADDi 16 1 // -src
1241: ADD 14 16 // a-b
1242: CPi 18 1246 // condition (P)
1243: BZJ 18 14 // condition
1244: CPi 18 1232 // wh loop
1245: BZJi 18 0 // loop
1246: CP 14 1339 // $slot.main.1
1247: CPi 15 10 // constant operand
1248: ADD 14 15 // +
1249: CP 18 14
1250: CPI 14 18 // deref
1251: CP 1336 14 // spill val
1252: CP 14 1340 // $slot.main.2
1253: CPi 18 1342 // $slot.main.4
1254: ADD 18 14 // +idx
1255: CP 14 1336 // reload val
1256: CPIi 18 14 // []=
1257: CP 14 1340 // $slot.main.2
1258: CPi 18 1342 // $slot.main.4
1259: ADD 18 14 // +idx
1260: CPI 14 18 // ld[]
1261: CP 1336 14 // spill val
1262: CP 14 1339 // $slot.main.1
1263: CP 15 1340 // $slot.main.2
1264: ADD 14 15 // +
1265: CP 18 14 // addr
1266: CP 14 1336 // reload val
1267: CPIi 18 14 // *=
1268: CP 14 1340 // $slot.main.2
1269: CPi 18 1342 // $slot.main.4
1270: ADD 18 14 // +idx
1271: CPI 14 18 // ld[]
1272: CP 16 14 // shift sign
1273: SRLi 16 31 // negative?
1274: CPi 18 1281 // nonnegative shift (P)
1275: BZJ 18 16 // nonnegative shift
1276: NAND 14 14 // ~negative
1277: SRLi 14 20 // >>
1278: NAND 14 14 // sign extension
1279: CPi 18 1282 // shift end (P)
1280: BZJi 18 0 // shift end
1281: SRLi 14 20 // >>
1282: CPi 15 4 // constant operand
1283: CP 16 15 // sub
1284: NAND 16 16 // ~
1285: ADDi 16 1 // -src
1286: ADD 14 16 // a-b
1287: CPi 18 1291 // condition fallthrough (P)
1288: BZJ 18 14 // condition fallthrough
1289: CPi 18 1303 // condition (P)
1290: BZJi 18 0 // condition
1291: CP 14 5 // constant
1292: CP 1336 14 // spill val
1293: CP 14 1339 // $slot.main.1
1294: CPi 15 12 // constant operand
1295: ADD 14 15 // +
1296: CP 18 14 // addr
1297: CP 14 1336 // reload val
1298: CPIi 18 14 // *=
1299: CP 14 3 // constant
1300: CPi 18 1323 // $RA.main
1301: CPI 15 18 // load RA
1302: BZJi 15 0 // return
1303: CP 14 1340 // $slot.main.2
1304: CP 15 4 // constant operand
1305: ADD 14 15 // +
1306: CP 1340 14 // direct store
1307: CPi 18 553 // wh loop
1308: BZJi 18 0 // loop
1309: CP 14 3 // constant
1310: CPi 18 1323 // $RA.main
1311: CPI 15 18 // load RA
1312: BZJi 15 0 // return
1313: CP 14 3 // ret 0
1314: CPi 18 1323 // $RA.main
1315: CPI 15 18 // load RA
1316: BZJi 15 0 // return
1317: BZJi 3 1317 // HALT
//$DATA_SECTION
1318: 0 // g'g_plus'
1319: 0 // g'g_minus'
1320: 1 // g'AG_count'
1321: 0 // g'$RA.BCD_compare_digit'
1322: 0 // g'$RA.score'
1323: 0 // g'$RA.main'
1324: 0 // g'$spill.BCD_compare_digit'
1325: 0 // g'$slot.BCD_compare_digit.0'
1326: 0 // g'$slot.BCD_compare_digit.1'
1327: 0 // g'$slot.BCD_compare_digit.2'
1328: 0 // g'$slot.BCD_compare_digit.3'
1329: 0 // g'$spill.score'[0]
1330: 0 // g'$spill.score'[1]
1331: 0 // g'$slot.score.0'
1332: 0 // g'$slot.score.1'
1333: 0 // g'$slot.score.2'
1334: 0 // g'$slot.score.3'
1335: 0 // g'$slot.score.4'
1336: 0 // g'$spill.main'[0]
1337: 0 // g'$spill.main'[1]
1338: 0 // g'$slot.main.0'
1339: 0 // g'$slot.main.1'
1340: 0 // g'$slot.main.2'
1341: 0 // g'$slot.main.3'
1342: 0 // g'$slot.main.4'[0]
1343: 0 // g'$slot.main.4'[1]
1344: 0 // g'$slot.main.4'[2]
1345: 0 // g'$slot.main.4'[3]
1346: 0 // g'$slot.main.4'[4]
1347: 0 // g'$slot.main.4'[5]
1348: 0 // g'$slot.main.4'[6]
1349: 0 // g'$slot.main.4'[7]
1350: 0 // g'$slot.main.4'[8]
1351: 0 // g'$slot.main.4'[9]
1352: 0 // g'$slot.main.5'
1353: 0 // g'$slot.main.6'[0]
1354: 0 // g'$slot.main.6'[1]
1355: 0 // g'$slot.main.6'[2]
1356: 0 // g'$slot.main.6'[3]
1357: 0 // g'$slot.main.6'[4]
1358: 0 // g'$slot.main.7'[0]
1359: 0 // g'$slot.main.7'[1]
1360: 0 // g'$slot.main.7'[2]
1361: 0 // g'$slot.main.7'[3]
1362: 0 // g'$slot.main.7'[4]
1363: 0 // g'$slot.main.8'[0]
1364: 0 // g'$slot.main.8'[1]
1365: 0 // g'$slot.main.8'[2]
1366: 0 // g'$slot.main.8'[3]
1367: 0 // g'$slot.main.8'[4]
1368: 0 // g'$slot.main.9'[0]
1369: 0 // g'$slot.main.9'[1]
1370: 0 // g'$slot.main.9'[2]
1371: 0 // g'$slot.main.9'[3]
1372: 0 // g'$slot.main.9'[4]
1373: 0 // g'$slot.main.10'
1374: 0 // g'$slot.main.11'
1375: 0 // g'$slot.main.12'
1376: 0 // g'$slot.main.13'[0]
1377: 0 // g'$slot.main.13'[1]
1378: 0 // g'$slot.main.13'[2]
1379: 0 // g'$slot.main.13'[3]
1380: 0 // g'$slot.main.13'[4]
1381: 0 // g'$slot.main.14'[0]
1382: 0 // g'$slot.main.14'[1]
1383: 0 // g'$slot.main.14'[2]
1384: 0 // g'$slot.main.14'[3]
1385: 0 // g'$slot.main.15'[0]
1386: 0 // g'$slot.main.15'[1]
1387: 0 // g'$slot.main.15'[2]
1388: 0 // g'$slot.main.16'
1389: 0 // g'$slot.main.17'
1390: 0 // g'$slot.main.18'
//$STACK_SECTION // none (stackless calling convention)
