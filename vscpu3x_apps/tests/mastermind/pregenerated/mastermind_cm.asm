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
21: CPi 18 1210 // $RA.main addr
22: CPi 15 1197 // HALT addr
23: CPIi 18 15 // RA.main = HALT
24: BZJi 3 927 // Goto main
25: CP 14 1215 // $slot.BCD_compare_digit.2
26: CP 15 1216 // $slot.BCD_compare_digit.3
27: CPi 19 8 // sign bias
28: SRLi 19 60 // 2^31
29: ADD 14 19 // signed lhs bias
30: ADD 15 19 // signed rhs bias
31: LT 15 14 // >
32: CP 14 15
33: CPi 18 71 // condition (P)
34: BZJ 18 14 // condition
35: CP 1217 1216 // direct assignment
36: CP 14 1213 // $slot.BCD_compare_digit.0
37: CP 1211 14 // spill lhs
38: CPi 14 4 // constant
39: CP 1212 14 // spill lhs
40: CP 14 1215 // $slot.BCD_compare_digit.2
41: CP 15 1216 // $slot.BCD_compare_digit.3
42: CP 16 15 // sub
43: NAND 16 16 // ~
44: ADDi 16 1 // -src
45: ADD 14 16 // a-b
46: CP 15 14 // rhs
47: CP 14 1212 // reload lhs
48: MUL 14 15 // *
49: CP 15 14 // rhs
50: CP 14 1211 // reload lhs
51: CP 16 15 // shift amount
52: LTi 16 32 // amount<32?
53: CPi 18 67 // shift>=32 (P)
54: BZJ 18 16 // shift>=32
55: CP 16 14 // shift sign
56: SRLi 16 31 // negative?
57: CPi 18 64 // nonnegative shift (P)
58: BZJ 18 16 // nonnegative shift
59: NAND 14 14 // ~negative
60: SRL 14 15 // >>
61: NAND 14 14 // sign extension
62: CPi 18 65 // shift end (P)
63: BZJi 18 0 // shift end
64: SRL 14 15 // >>
65: CPi 18 68 // shift end (P)
66: BZJi 18 0 // shift end
67: CPi 14 0 // shift>=32
68: CP 1213 14 // direct store
69: CPi 18 105 // if end (P)
70: BZJi 18 0 // if end
71: CP 1217 1215 // direct assignment
72: CP 14 1214 // $slot.BCD_compare_digit.1
73: CP 1211 14 // spill lhs
74: CPi 14 4 // constant
75: CP 1212 14 // spill lhs
76: CP 14 1216 // $slot.BCD_compare_digit.3
77: CP 15 1215 // $slot.BCD_compare_digit.2
78: CP 16 15 // sub
79: NAND 16 16 // ~
80: ADDi 16 1 // -src
81: ADD 14 16 // a-b
82: CP 15 14 // rhs
83: CP 14 1212 // reload lhs
84: MUL 14 15 // *
85: CP 15 14 // rhs
86: CP 14 1211 // reload lhs
87: CP 16 15 // shift amount
88: LTi 16 32 // amount<32?
89: CPi 18 103 // shift>=32 (P)
90: BZJ 18 16 // shift>=32
91: CP 16 14 // shift sign
92: SRLi 16 31 // negative?
93: CPi 18 100 // nonnegative shift (P)
94: BZJ 18 16 // nonnegative shift
95: NAND 14 14 // ~negative
96: SRL 14 15 // >>
97: NAND 14 14 // sign extension
98: CPi 18 101 // shift end (P)
99: BZJi 18 0 // shift end
100: SRL 14 15 // >>
101: CPi 18 104 // shift end (P)
102: BZJi 18 0 // shift end
103: CPi 14 0 // shift>=32
104: CP 1214 14 // direct store
105: CP 14 1213 // $slot.BCD_compare_digit.0
106: CP 1211 14 // spill lhs
107: CP 14 1214 // $slot.BCD_compare_digit.1
108: NAND 14 14 // ~
109: CP 15 14 // rhs
110: CP 14 1211 // reload lhs
111: NAND 14 15 // nand
112: NAND 14 14 // and
113: CP 1211 14 // spill lhs
114: CP 14 1213 // $slot.BCD_compare_digit.0
115: NAND 14 14 // ~
116: CP 15 1214 // $slot.BCD_compare_digit.1
117: NAND 14 15 // nand
118: NAND 14 14 // and
119: CP 15 14 // rhs
120: CP 14 1211 // reload lhs
121: CP 16 14 // or
122: NAND 16 16 // ~a
123: CP 17 15
124: NAND 17 17 // ~b
125: NAND 16 17 // a|b
126: CP 14 16
127: CP 1215 14 // direct store
128: CP 14 1215 // $slot.BCD_compare_digit.2
129: CP 1211 14 // spill lhs
130: CP 14 1217 // $slot.BCD_compare_digit.4
131: CP 15 4 // constant operand
132: CP 16 15 // sub
133: NAND 16 16 // ~
134: ADDi 16 1 // -src
135: ADD 14 16 // a-b
136: CPi 15 4 // constant operand
137: MUL 14 15 // *
138: CP 15 14 // rhs
139: CP 14 1211 // reload lhs
140: CP 16 15 // shift amount
141: LTi 16 32 // amount<32?
142: CPi 18 156 // shift>=32 (P)
143: BZJ 18 16 // shift>=32
144: CP 16 14 // shift sign
145: SRLi 16 31 // negative?
146: CPi 18 153 // nonnegative shift (P)
147: BZJ 18 16 // nonnegative shift
148: NAND 14 14 // ~negative
149: SRL 14 15 // >>
150: NAND 14 14 // sign extension
151: CPi 18 154 // shift end (P)
152: BZJi 18 0 // shift end
153: SRL 14 15 // >>
154: CPi 18 157 // shift end (P)
155: BZJi 18 0 // shift end
156: CPi 14 0 // shift>=32
157: CP 1215 14 // direct store
158: CP 1213 5 // direct assignment
159: CP 14 1213 // $slot.BCD_compare_digit.0
160: CPi 15 15 // constant operand
161: CP 16 15 // sub
162: NAND 16 16 // ~
163: ADDi 16 1 // -src
164: ADD 14 16 // a-b
165: CP 1213 14 // direct store
166: CP 14 1215 // $slot.BCD_compare_digit.2
167: CP 15 1213 // $slot.BCD_compare_digit.0
168: NAND 14 15 // nand
169: NAND 14 14 // and
170: CP 1214 14 // direct store
171: CP 14 1214 // $slot.BCD_compare_digit.1
172: CP 15 1215 // $slot.BCD_compare_digit.2
173: CP 16 15 // sub
174: NAND 16 16 // ~
175: ADDi 16 1 // -src
176: ADD 14 16 // a-b
177: CPi 18 181 // condition fallthrough (P)
178: BZJ 18 14 // condition fallthrough
179: CPi 18 185 // condition (P)
180: BZJi 18 0 // condition
181: CP 14 4 // constant
182: CPi 18 1200 // $RA.BCD_compare_digit
183: CPI 15 18 // load RA
184: BZJi 15 0 // return
185: CP 14 3 // constant
186: CPi 18 1200 // $RA.BCD_compare_digit
187: CPI 15 18 // load RA
188: BZJi 15 0 // return
189: CP 14 3 // ret 0
190: CPi 18 1200 // $RA.BCD_compare_digit
191: CPI 15 18 // load RA
192: BZJi 15 0 // return
193: CPi 1198 0 // direct assignment
194: CPi 1199 0 // direct assignment
195: CPi 1221 0 // init local
196: CPi 1222 0 // init local
197: CPi 1223 1 // direct assignment
198: CP 14 1223 // $slot.score.4
199: CPi 15 4 // constant operand
200: CPi 19 8 // sign bias
201: SRLi 19 60 // 2^31
202: ADD 14 19 // signed lhs bias
203: ADD 15 19 // signed rhs bias
204: LT 15 14 // b<a
205: CP 14 15
206: LTi 14 1 // !
207: CPi 18 288 // condition (P)
208: BZJ 18 14 // condition
209: CP 14 4 // constant
210: CP 1218 14 // spill lhs
211: CP 14 1223 // $slot.score.4
212: CP 15 4 // constant operand
213: CP 16 15 // sub
214: NAND 16 16 // ~
215: ADDi 16 1 // -src
216: ADD 14 16 // a-b
217: CP 15 14 // rhs
218: CP 14 1218 // reload lhs
219: CP 16 15 // shift amount
220: LTi 16 32 // amount<32?
221: CPi 18 227 // shift>=32 (P)
222: BZJ 18 16 // shift>=32
223: ADDi 15 32 // left shift encoding
224: SRL 14 15 // <<
225: CPi 18 228 // shift end (P)
226: BZJi 18 0 // shift end
227: CPi 14 0 // shift>=32
228: CP 1225 14 // direct store
229: CP 14 1221 // $slot.score.2
230: CP 15 1222 // $slot.score.3
231: CP 16 14 // or
232: NAND 16 16 // ~a
233: CP 17 15
234: NAND 17 17 // ~b
235: NAND 16 17 // a|b
236: CP 14 16
237: CP 15 1225 // $slot.score.6
238: NAND 14 15 // nand
239: NAND 14 14 // and
240: CP 15 1225 // $slot.score.6
241: CP 16 15 // sub
242: NAND 16 16 // ~
243: ADDi 16 1 // -src
244: ADD 14 16 // a-b
245: CPi 18 249 // condition fallthrough (P)
246: BZJ 18 14 // condition fallthrough
247: CPi 18 251 // condition (P)
248: BZJi 18 0 // condition
249: CPi 18 285 // continue (P)
250: BZJi 18 0 // continue
251: CP 14 1219 // $slot.score.0
252: CPi 18 1213 // $slot.BCD_compare_digit.0
253: CPIi 18 14 // st param
254: CP 14 1220 // $slot.score.1
255: CPi 18 1214 // $slot.BCD_compare_digit.1
256: CPIi 18 14 // st param
257: CP 14 1223 // $slot.score.4
258: CPi 18 1215 // $slot.BCD_compare_digit.2
259: CPIi 18 14 // st param
260: CP 14 1223 // $slot.score.4
261: CPi 18 1216 // $slot.BCD_compare_digit.3
262: CPIi 18 14 // st param
263: CPi 18 1200 // $RA.BCD_compare_digit
264: CPi 15 268 // retPC
265: CPIi 18 15 // st RA
266: CPi 18 25 // BCD_compare_digit
267: BZJi 18 0 // BCD_compare_digit
268: CP 1224 14 // direct store
269: CP 14 1224 // $slot.score.5
270: CPi 18 285 // condition (P)
271: BZJ 18 14 // condition
272: CP 14 1221 // $slot.score.2
273: CP 15 1225 // $slot.score.6
274: CP 16 14 // or
275: NAND 16 16 // ~a
276: CP 17 15
277: NAND 17 17 // ~b
278: NAND 16 17 // a|b
279: CP 14 16
280: CP 1221 14 // direct store
281: CP 1222 1221 // direct assignment
282: ADDi 1198 1 // direct ++
283: CPi 18 285 // continue (P)
284: BZJi 18 0 // continue
285: ADDi 1223 1 // direct ++
286: CPi 18 198 // for
287: BZJi 18 0 // loop
288: CPi 1223 1 // direct assignment
289: CP 14 1223 // $slot.score.4
290: CPi 15 4 // constant operand
291: CPi 19 8 // sign bias
292: SRLi 19 60 // 2^31
293: ADD 14 19 // signed lhs bias
294: ADD 15 19 // signed rhs bias
295: LT 15 14 // b<a
296: CP 14 15
297: LTi 14 1 // !
298: CPi 18 434 // condition (P)
299: BZJ 18 14 // condition
300: CPi 1226 1 // direct assignment
301: CP 14 1226 // $slot.score.7
302: CPi 15 4 // constant operand
303: CPi 19 8 // sign bias
304: SRLi 19 60 // 2^31
305: ADD 14 19 // signed lhs bias
306: ADD 15 19 // signed rhs bias
307: LT 15 14 // b<a
308: CP 14 15
309: LTi 14 1 // !
310: CPi 18 431 // condition (P)
311: BZJ 18 14 // condition
312: CP 14 4 // constant
313: CP 1218 14 // spill lhs
314: CP 14 1223 // $slot.score.4
315: CP 15 4 // constant operand
316: CP 16 15 // sub
317: NAND 16 16 // ~
318: ADDi 16 1 // -src
319: ADD 14 16 // a-b
320: CP 15 14 // rhs
321: CP 14 1218 // reload lhs
322: CP 16 15 // shift amount
323: LTi 16 32 // amount<32?
324: CPi 18 330 // shift>=32 (P)
325: BZJ 18 16 // shift>=32
326: ADDi 15 32 // left shift encoding
327: SRL 14 15 // <<
328: CPi 18 331 // shift end (P)
329: BZJi 18 0 // shift end
330: CPi 14 0 // shift>=32
331: CP 1225 14 // direct store
332: CP 14 4 // constant
333: CP 1218 14 // spill lhs
334: CP 14 1226 // $slot.score.7
335: CP 15 4 // constant operand
336: CP 16 15 // sub
337: NAND 16 16 // ~
338: ADDi 16 1 // -src
339: ADD 14 16 // a-b
340: CP 15 14 // rhs
341: CP 14 1218 // reload lhs
342: CP 16 15 // shift amount
343: LTi 16 32 // amount<32?
344: CPi 18 350 // shift>=32 (P)
345: BZJ 18 16 // shift>=32
346: ADDi 15 32 // left shift encoding
347: SRL 14 15 // <<
348: CPi 18 351 // shift end (P)
349: BZJi 18 0 // shift end
350: CPi 14 0 // shift>=32
351: CP 1227 14 // direct store
352: CP 14 1221 // $slot.score.2
353: CP 15 1225 // $slot.score.6
354: NAND 14 15 // nand
355: NAND 14 14 // and
356: CP 15 1225 // $slot.score.6
357: CP 16 15 // sub
358: NAND 16 16 // ~
359: ADDi 16 1 // -src
360: ADD 14 16 // a-b
361: CPi 18 384 // condition (P)
362: BZJ 18 14 // condition
363: CP 14 1222 // $slot.score.3
364: CP 15 1227 // $slot.score.8
365: NAND 14 15 // nand
366: NAND 14 14 // and
367: CP 15 1227 // $slot.score.8
368: CP 16 15 // sub
369: NAND 16 16 // ~
370: ADDi 16 1 // -src
371: ADD 14 16 // a-b
372: CPi 18 384 // condition (P)
373: BZJ 18 14 // condition
374: CP 14 1223 // $slot.score.4
375: CP 15 1226 // $slot.score.7
376: CP 16 15 // sub
377: NAND 16 16 // ~
378: ADDi 16 1 // -src
379: ADD 14 16 // a-b
380: CPi 18 384 // condition fallthrough (P)
381: BZJ 18 14 // condition fallthrough
382: CPi 18 386 // condition (P)
383: BZJi 18 0 // condition
384: CPi 18 428 // continue (P)
385: BZJi 18 0 // continue
386: CP 14 1219 // $slot.score.0
387: CPi 18 1213 // $slot.BCD_compare_digit.0
388: CPIi 18 14 // st param
389: CP 14 1220 // $slot.score.1
390: CPi 18 1214 // $slot.BCD_compare_digit.1
391: CPIi 18 14 // st param
392: CP 14 1223 // $slot.score.4
393: CPi 18 1215 // $slot.BCD_compare_digit.2
394: CPIi 18 14 // st param
395: CP 14 1226 // $slot.score.7
396: CPi 18 1216 // $slot.BCD_compare_digit.3
397: CPIi 18 14 // st param
398: CPi 18 1200 // $RA.BCD_compare_digit
399: CPi 15 403 // retPC
400: CPIi 18 15 // st RA
401: CPi 18 25 // BCD_compare_digit
402: BZJi 18 0 // BCD_compare_digit
403: CP 1224 14 // direct store
404: CP 14 1224 // $slot.score.5
405: CPi 18 428 // condition (P)
406: BZJ 18 14 // condition
407: ADDi 1199 1 // direct ++
408: CP 14 1221 // $slot.score.2
409: CP 15 1225 // $slot.score.6
410: CP 16 14 // or
411: NAND 16 16 // ~a
412: CP 17 15
413: NAND 17 17 // ~b
414: NAND 16 17 // a|b
415: CP 14 16
416: CP 1221 14 // direct store
417: CP 14 1222 // $slot.score.3
418: CP 15 1227 // $slot.score.8
419: CP 16 14 // or
420: NAND 16 16 // ~a
421: CP 17 15
422: NAND 17 17 // ~b
423: NAND 16 17 // a|b
424: CP 14 16
425: CP 1222 14 // direct store
426: CPi 18 431 // break (P)
427: BZJi 18 0 // break
428: ADDi 1226 1 // direct ++
429: CPi 18 301 // for
430: BZJi 18 0 // loop
431: ADDi 1223 1 // direct ++
432: CPi 18 289 // for
433: BZJi 18 0 // loop
434: CP 14 3 // ret 0
435: CPi 18 1201 // $RA.score
436: CPI 15 18 // load RA
437: BZJi 15 0 // return
438: CPi 1228 8448 // init local
439: CP 14 1228 // $slot.wait_tx.0
440: CPi 15 5 // constant operand
441: ADD 14 15 // +
442: CP 18 14
443: CPI 14 18 // deref
444: CP 1229 14 // direct store
445: CP 14 1229 // $slot.wait_tx.1
446: CP 15 4 // constant operand
447: NAND 14 15 // nand
448: NAND 14 14 // and
449: CP 1229 14 // direct store
450: CP 14 1229 // $slot.wait_tx.1
451: CP 15 4 // constant operand
452: CP 16 15 // sub
453: NAND 16 16 // ~
454: ADDi 16 1 // -src
455: ADD 14 16 // a-b
456: CPi 18 460 // condition fallthrough (P)
457: BZJ 18 14 // condition fallthrough
458: CPi 18 473 // condition (P)
459: BZJi 18 0 // condition
460: CP 14 1228 // $slot.wait_tx.0
461: CPi 15 5 // constant operand
462: ADD 14 15 // +
463: CP 18 14
464: CPI 14 18 // deref
465: CP 1229 14 // direct store
466: CP 14 1229 // $slot.wait_tx.1
467: CP 15 4 // constant operand
468: NAND 14 15 // nand
469: NAND 14 14 // and
470: CP 1229 14 // direct store
471: CPi 18 450 // wh loop
472: BZJi 18 0 // loop
473: CP 14 3 // ret 0
474: CPi 18 1202 // $RA.wait_tx
475: CPI 15 18 // load RA
476: BZJi 15 0 // return
477: CPi 1230 10000 // init local
478: CPi 1231 8448 // init local
479: CP 14 1231 // $slot.wait_for_tx_drain.1
480: CPi 15 4 // constant operand
481: ADD 14 15 // +
482: CP 18 14
483: CPI 14 18 // deref
484: CP 15 3 // constant operand
485: CP 16 15 // sub
486: NAND 16 16 // ~
487: ADDi 16 1 // -src
488: ADD 14 16 // a-b
489: CPi 18 493 // condition (P)
490: BZJ 18 14 // condition
491: CPi 18 479 // wh loop
492: BZJi 18 0 // loop
493: CP 14 1230 // $slot.wait_for_tx_drain.0
494: CP 15 3 // constant operand
495: CPi 19 8 // sign bias
496: SRLi 19 60 // 2^31
497: ADD 14 19 // signed lhs bias
498: ADD 15 19 // signed rhs bias
499: LT 15 14 // >
500: CP 14 15
501: CPi 18 506 // condition (P)
502: BZJ 18 14 // condition
503: ADD 1230 5 // direct --
504: CPi 18 493 // wh loop
505: BZJi 18 0 // loop
506: CP 14 3 // ret 0
507: CPi 18 1203 // $RA.wait_for_tx_drain
508: CPI 15 18 // load RA
509: BZJi 15 0 // return
510: CPi 1233 8448 // init local
511: CPi 18 1202 // $RA.wait_tx
512: CPi 15 516 // retPC
513: CPIi 18 15 // st RA
514: CPi 18 438 // wait_tx
515: BZJi 18 0 // wait_tx
516: CPi 14 102 // constant
517: CP 1232 14 // spill val
518: CP 14 1233 // $slot.print_found.0
519: CPi 15 3 // constant operand
520: ADD 14 15 // +
521: CP 18 14 // addr
522: CP 14 1232 // reload val
523: CPIi 18 14 // *=
524: CP 14 4 // constant
525: CP 1232 14 // spill val
526: CP 14 1233 // $slot.print_found.0
527: CPi 15 4 // constant operand
528: ADD 14 15 // +
529: CP 18 14 // addr
530: CP 14 1232 // reload val
531: CPIi 18 14 // *=
532: CPi 18 1202 // $RA.wait_tx
533: CPi 15 537 // retPC
534: CPIi 18 15 // st RA
535: CPi 18 438 // wait_tx
536: BZJi 18 0 // wait_tx
537: CPi 14 111 // constant
538: CP 1232 14 // spill val
539: CP 14 1233 // $slot.print_found.0
540: CPi 15 3 // constant operand
541: ADD 14 15 // +
542: CP 18 14 // addr
543: CP 14 1232 // reload val
544: CPIi 18 14 // *=
545: CP 14 4 // constant
546: CP 1232 14 // spill val
547: CP 14 1233 // $slot.print_found.0
548: CPi 15 4 // constant operand
549: ADD 14 15 // +
550: CP 18 14 // addr
551: CP 14 1232 // reload val
552: CPIi 18 14 // *=
553: CPi 18 1202 // $RA.wait_tx
554: CPi 15 558 // retPC
555: CPIi 18 15 // st RA
556: CPi 18 438 // wait_tx
557: BZJi 18 0 // wait_tx
558: CPi 14 117 // constant
559: CP 1232 14 // spill val
560: CP 14 1233 // $slot.print_found.0
561: CPi 15 3 // constant operand
562: ADD 14 15 // +
563: CP 18 14 // addr
564: CP 14 1232 // reload val
565: CPIi 18 14 // *=
566: CP 14 4 // constant
567: CP 1232 14 // spill val
568: CP 14 1233 // $slot.print_found.0
569: CPi 15 4 // constant operand
570: ADD 14 15 // +
571: CP 18 14 // addr
572: CP 14 1232 // reload val
573: CPIi 18 14 // *=
574: CPi 18 1202 // $RA.wait_tx
575: CPi 15 579 // retPC
576: CPIi 18 15 // st RA
577: CPi 18 438 // wait_tx
578: BZJi 18 0 // wait_tx
579: CPi 14 110 // constant
580: CP 1232 14 // spill val
581: CP 14 1233 // $slot.print_found.0
582: CPi 15 3 // constant operand
583: ADD 14 15 // +
584: CP 18 14 // addr
585: CP 14 1232 // reload val
586: CPIi 18 14 // *=
587: CP 14 4 // constant
588: CP 1232 14 // spill val
589: CP 14 1233 // $slot.print_found.0
590: CPi 15 4 // constant operand
591: ADD 14 15 // +
592: CP 18 14 // addr
593: CP 14 1232 // reload val
594: CPIi 18 14 // *=
595: CPi 18 1202 // $RA.wait_tx
596: CPi 15 600 // retPC
597: CPIi 18 15 // st RA
598: CPi 18 438 // wait_tx
599: BZJi 18 0 // wait_tx
600: CPi 14 100 // constant
601: CP 1232 14 // spill val
602: CP 14 1233 // $slot.print_found.0
603: CPi 15 3 // constant operand
604: ADD 14 15 // +
605: CP 18 14 // addr
606: CP 14 1232 // reload val
607: CPIi 18 14 // *=
608: CP 14 4 // constant
609: CP 1232 14 // spill val
610: CP 14 1233 // $slot.print_found.0
611: CPi 15 4 // constant operand
612: ADD 14 15 // +
613: CP 18 14 // addr
614: CP 14 1232 // reload val
615: CPIi 18 14 // *=
616: CP 14 3 // ret 0
617: CPi 18 1204 // $RA.print_found
618: CPI 15 18 // load RA
619: BZJi 15 0 // return
620: CPi 1236 8448 // init local
621: CPi 18 1202 // $RA.wait_tx
622: CPi 15 626 // retPC
623: CPIi 18 15 // st RA
624: CPi 18 438 // wait_tx
625: BZJi 18 0 // wait_tx
626: CP 14 1235 // $slot.print_code.0
627: CP 16 14 // shift sign
628: SRLi 16 31 // negative?
629: CPi 18 636 // nonnegative shift (P)
630: BZJ 18 16 // nonnegative shift
631: NAND 14 14 // ~negative
632: SRLi 14 12 // >>
633: NAND 14 14 // sign extension
634: CPi 18 637 // shift end (P)
635: BZJi 18 0 // shift end
636: SRLi 14 12 // >>
637: CPi 15 48 // constant operand
638: ADD 14 15 // +
639: CP 1234 14 // spill val
640: CP 14 1236 // $slot.print_code.1
641: CPi 15 3 // constant operand
642: ADD 14 15 // +
643: CP 18 14 // addr
644: CP 14 1234 // reload val
645: CPIi 18 14 // *=
646: CP 14 4 // constant
647: CP 1234 14 // spill val
648: CP 14 1236 // $slot.print_code.1
649: CPi 15 4 // constant operand
650: ADD 14 15 // +
651: CP 18 14 // addr
652: CP 14 1234 // reload val
653: CPIi 18 14 // *=
654: CPi 18 1202 // $RA.wait_tx
655: CPi 15 659 // retPC
656: CPIi 18 15 // st RA
657: CPi 18 438 // wait_tx
658: BZJi 18 0 // wait_tx
659: CP 14 1235 // $slot.print_code.0
660: CP 16 14 // shift sign
661: SRLi 16 31 // negative?
662: CPi 18 669 // nonnegative shift (P)
663: BZJ 18 16 // nonnegative shift
664: NAND 14 14 // ~negative
665: SRLi 14 8 // >>
666: NAND 14 14 // sign extension
667: CPi 18 670 // shift end (P)
668: BZJi 18 0 // shift end
669: SRLi 14 8 // >>
670: CPi 15 15 // constant operand
671: NAND 14 15 // nand
672: NAND 14 14 // and
673: CPi 15 48 // constant operand
674: ADD 14 15 // +
675: CP 1234 14 // spill val
676: CP 14 1236 // $slot.print_code.1
677: CPi 15 3 // constant operand
678: ADD 14 15 // +
679: CP 18 14 // addr
680: CP 14 1234 // reload val
681: CPIi 18 14 // *=
682: CP 14 4 // constant
683: CP 1234 14 // spill val
684: CP 14 1236 // $slot.print_code.1
685: CPi 15 4 // constant operand
686: ADD 14 15 // +
687: CP 18 14 // addr
688: CP 14 1234 // reload val
689: CPIi 18 14 // *=
690: CPi 18 1202 // $RA.wait_tx
691: CPi 15 695 // retPC
692: CPIi 18 15 // st RA
693: CPi 18 438 // wait_tx
694: BZJi 18 0 // wait_tx
695: CP 14 1235 // $slot.print_code.0
696: CP 16 14 // shift sign
697: SRLi 16 31 // negative?
698: CPi 18 705 // nonnegative shift (P)
699: BZJ 18 16 // nonnegative shift
700: NAND 14 14 // ~negative
701: SRLi 14 4 // >>
702: NAND 14 14 // sign extension
703: CPi 18 706 // shift end (P)
704: BZJi 18 0 // shift end
705: SRLi 14 4 // >>
706: CPi 15 15 // constant operand
707: NAND 14 15 // nand
708: NAND 14 14 // and
709: CPi 15 48 // constant operand
710: ADD 14 15 // +
711: CP 1234 14 // spill val
712: CP 14 1236 // $slot.print_code.1
713: CPi 15 3 // constant operand
714: ADD 14 15 // +
715: CP 18 14 // addr
716: CP 14 1234 // reload val
717: CPIi 18 14 // *=
718: CP 14 4 // constant
719: CP 1234 14 // spill val
720: CP 14 1236 // $slot.print_code.1
721: CPi 15 4 // constant operand
722: ADD 14 15 // +
723: CP 18 14 // addr
724: CP 14 1234 // reload val
725: CPIi 18 14 // *=
726: CPi 18 1202 // $RA.wait_tx
727: CPi 15 731 // retPC
728: CPIi 18 15 // st RA
729: CPi 18 438 // wait_tx
730: BZJi 18 0 // wait_tx
731: CP 14 1235 // $slot.print_code.0
732: CPi 15 15 // constant operand
733: NAND 14 15 // nand
734: NAND 14 14 // and
735: CPi 15 48 // constant operand
736: ADD 14 15 // +
737: CP 1234 14 // spill val
738: CP 14 1236 // $slot.print_code.1
739: CPi 15 3 // constant operand
740: ADD 14 15 // +
741: CP 18 14 // addr
742: CP 14 1234 // reload val
743: CPIi 18 14 // *=
744: CP 14 4 // constant
745: CP 1234 14 // spill val
746: CP 14 1236 // $slot.print_code.1
747: CPi 15 4 // constant operand
748: ADD 14 15 // +
749: CP 18 14 // addr
750: CP 14 1234 // reload val
751: CPIi 18 14 // *=
752: CP 14 3 // ret 0
753: CPi 18 1205 // $RA.print_code
754: CPI 15 18 // load RA
755: BZJi 15 0 // return
756: CPi 1238 8448 // init local
757: CPi 18 1202 // $RA.wait_tx
758: CPi 15 762 // retPC
759: CPIi 18 15 // st RA
760: CPi 18 438 // wait_tx
761: BZJi 18 0 // wait_tx
762: CPi 14 13 // constant
763: CP 1237 14 // spill val
764: CP 14 1238 // $slot.print_new_line.0
765: CPi 15 3 // constant operand
766: ADD 14 15 // +
767: CP 18 14 // addr
768: CP 14 1237 // reload val
769: CPIi 18 14 // *=
770: CP 14 4 // constant
771: CP 1237 14 // spill val
772: CP 14 1238 // $slot.print_new_line.0
773: CPi 15 4 // constant operand
774: ADD 14 15 // +
775: CP 18 14 // addr
776: CP 14 1237 // reload val
777: CPIi 18 14 // *=
778: CPi 18 1202 // $RA.wait_tx
779: CPi 15 783 // retPC
780: CPIi 18 15 // st RA
781: CPi 18 438 // wait_tx
782: BZJi 18 0 // wait_tx
783: CPi 14 10 // constant
784: CP 1237 14 // spill val
785: CP 14 1238 // $slot.print_new_line.0
786: CPi 15 3 // constant operand
787: ADD 14 15 // +
788: CP 18 14 // addr
789: CP 14 1237 // reload val
790: CPIi 18 14 // *=
791: CP 14 4 // constant
792: CP 1237 14 // spill val
793: CP 14 1238 // $slot.print_new_line.0
794: CPi 15 4 // constant operand
795: ADD 14 15 // +
796: CP 18 14 // addr
797: CP 14 1237 // reload val
798: CPIi 18 14 // *=
799: CP 14 3 // ret 0
800: CPi 18 1206 // $RA.print_new_line
801: CPI 15 18 // load RA
802: BZJi 15 0 // return
803: CPi 1240 8448 // init local
804: CPi 18 1202 // $RA.wait_tx
805: CPi 15 809 // retPC
806: CPIi 18 15 // st RA
807: CPi 18 438 // wait_tx
808: BZJi 18 0 // wait_tx
809: CPi 14 32 // constant
810: CP 1239 14 // spill val
811: CP 14 1240 // $slot.print_space.0
812: CPi 15 3 // constant operand
813: ADD 14 15 // +
814: CP 18 14 // addr
815: CP 14 1239 // reload val
816: CPIi 18 14 // *=
817: CP 14 4 // constant
818: CP 1239 14 // spill val
819: CP 14 1240 // $slot.print_space.0
820: CPi 15 4 // constant operand
821: ADD 14 15 // +
822: CP 18 14 // addr
823: CP 14 1239 // reload val
824: CPIi 18 14 // *=
825: CP 14 3 // ret 0
826: CPi 18 1207 // $RA.print_space
827: CPI 15 18 // load RA
828: BZJi 15 0 // return
829: CPi 1242 8448 // init local
830: CPi 18 1202 // $RA.wait_tx
831: CPi 15 835 // retPC
832: CPIi 18 15 // st RA
833: CPi 18 438 // wait_tx
834: BZJi 18 0 // wait_tx
835: CPi 14 43 // constant
836: CP 1241 14 // spill val
837: CP 14 1242 // $slot.print_plus.0
838: CPi 15 3 // constant operand
839: ADD 14 15 // +
840: CP 18 14 // addr
841: CP 14 1241 // reload val
842: CPIi 18 14 // *=
843: CP 14 4 // constant
844: CP 1241 14 // spill val
845: CP 14 1242 // $slot.print_plus.0
846: CPi 15 4 // constant operand
847: ADD 14 15 // +
848: CP 18 14 // addr
849: CP 14 1241 // reload val
850: CPIi 18 14 // *=
851: CPi 18 1202 // $RA.wait_tx
852: CPi 15 856 // retPC
853: CPIi 18 15 // st RA
854: CPi 18 438 // wait_tx
855: BZJi 18 0 // wait_tx
856: CPi 14 48 // constant
857: CP 15 1198 // plus
858: ADD 14 15 // +
859: CP 1241 14 // spill val
860: CP 14 1242 // $slot.print_plus.0
861: CPi 15 3 // constant operand
862: ADD 14 15 // +
863: CP 18 14 // addr
864: CP 14 1241 // reload val
865: CPIi 18 14 // *=
866: CP 14 4 // constant
867: CP 1241 14 // spill val
868: CP 14 1242 // $slot.print_plus.0
869: CPi 15 4 // constant operand
870: ADD 14 15 // +
871: CP 18 14 // addr
872: CP 14 1241 // reload val
873: CPIi 18 14 // *=
874: CP 14 3 // ret 0
875: CPi 18 1208 // $RA.print_plus
876: CPI 15 18 // load RA
877: BZJi 15 0 // return
878: CPi 1244 8448 // init local
879: CPi 18 1202 // $RA.wait_tx
880: CPi 15 884 // retPC
881: CPIi 18 15 // st RA
882: CPi 18 438 // wait_tx
883: BZJi 18 0 // wait_tx
884: CPi 14 45 // constant
885: CP 1243 14 // spill val
886: CP 14 1244 // $slot.print_minus.0
887: CPi 15 3 // constant operand
888: ADD 14 15 // +
889: CP 18 14 // addr
890: CP 14 1243 // reload val
891: CPIi 18 14 // *=
892: CP 14 4 // constant
893: CP 1243 14 // spill val
894: CP 14 1244 // $slot.print_minus.0
895: CPi 15 4 // constant operand
896: ADD 14 15 // +
897: CP 18 14 // addr
898: CP 14 1243 // reload val
899: CPIi 18 14 // *=
900: CPi 18 1202 // $RA.wait_tx
901: CPi 15 905 // retPC
902: CPIi 18 15 // st RA
903: CPi 18 438 // wait_tx
904: BZJi 18 0 // wait_tx
905: CPi 14 48 // constant
906: CP 15 1199 // minus
907: ADD 14 15 // +
908: CP 1243 14 // spill val
909: CP 14 1244 // $slot.print_minus.0
910: CPi 15 3 // constant operand
911: ADD 14 15 // +
912: CP 18 14 // addr
913: CP 14 1243 // reload val
914: CPIi 18 14 // *=
915: CP 14 4 // constant
916: CP 1243 14 // spill val
917: CP 14 1244 // $slot.print_minus.0
918: CPi 15 4 // constant operand
919: ADD 14 15 // +
920: CP 18 14 // addr
921: CP 14 1243 // reload val
922: CPIi 18 14 // *=
923: CP 14 3 // ret 0
924: CPi 18 1209 // $RA.print_minus
925: CPI 15 18 // load RA
926: BZJi 15 0 // return
927: CPi 14 1 // constant
928: SRLi 14 46 // <<14
929: ADDi 14 5461 // low
930: CP 1246 14 // $slot.main.0
931: CPi 1247 0 // init local
932: CPi 1248 0 // init local
933: CPi 1249 0 // init local
934: CPi 1249 8192 // init local
935: CPi 1250 8464 // init local
936: CPi 1251 8448 // init local
937: CPi 1252 0 // init local
938: CP 14 4 // constant
939: CP 1245 14 // spill val
940: CP 14 1249 // $slot.main.3
941: CPi 15 11 // constant operand
942: ADD 14 15 // +
943: CP 18 14 // addr
944: CP 14 1245 // reload val
945: CPIi 18 14 // *=
946: CP 14 4 // constant
947: CP 1245 14 // spill val
948: CP 14 1250 // $slot.main.4
949: CP 18 14 // addr
950: CP 14 1245 // reload val
951: CPIi 18 14 // *=
952: CPi 18 1202 // $RA.wait_tx
953: CPi 15 957 // retPC
954: CPIi 18 15 // st RA
955: CPi 18 438 // wait_tx
956: BZJi 18 0 // wait_tx
957: CPi 14 115 // constant
958: CP 1245 14 // spill val
959: CP 14 1251 // $slot.main.5
960: CPi 15 3 // constant operand
961: ADD 14 15 // +
962: CP 18 14 // addr
963: CP 14 1245 // reload val
964: CPIi 18 14 // *=
965: CP 14 4 // constant
966: CP 1245 14 // spill val
967: CP 14 1251 // $slot.main.5
968: CPi 15 4 // constant operand
969: ADD 14 15 // +
970: CP 18 14 // addr
971: CP 14 1245 // reload val
972: CPIi 18 14 // *=
973: CPi 18 1202 // $RA.wait_tx
974: CPi 15 978 // retPC
975: CPIi 18 15 // st RA
976: CPi 18 438 // wait_tx
977: BZJi 18 0 // wait_tx
978: CPi 14 99 // constant
979: CP 1245 14 // spill val
980: CP 14 1251 // $slot.main.5
981: CPi 15 3 // constant operand
982: ADD 14 15 // +
983: CP 18 14 // addr
984: CP 14 1245 // reload val
985: CPIi 18 14 // *=
986: CP 14 4 // constant
987: CP 1245 14 // spill val
988: CP 14 1251 // $slot.main.5
989: CPi 15 4 // constant operand
990: ADD 14 15 // +
991: CP 18 14 // addr
992: CP 14 1245 // reload val
993: CPIi 18 14 // *=
994: CPi 18 1202 // $RA.wait_tx
995: CPi 15 999 // retPC
996: CPIi 18 15 // st RA
997: CPi 18 438 // wait_tx
998: BZJi 18 0 // wait_tx
999: CPi 14 58 // constant
1000: CP 1245 14 // spill val
1001: CP 14 1251 // $slot.main.5
1002: CPi 15 3 // constant operand
1003: ADD 14 15 // +
1004: CP 18 14 // addr
1005: CP 14 1245 // reload val
1006: CPIi 18 14 // *=
1007: CP 14 4 // constant
1008: CP 1245 14 // spill val
1009: CP 14 1251 // $slot.main.5
1010: CPi 15 4 // constant operand
1011: ADD 14 15 // +
1012: CP 18 14 // addr
1013: CP 14 1245 // reload val
1014: CPIi 18 14 // *=
1015: CP 14 1246 // $slot.main.0
1016: CPi 18 1235 // $slot.print_code.0
1017: CPIi 18 14 // st param
1018: CPi 18 1205 // $RA.print_code
1019: CPi 15 1023 // retPC
1020: CPIi 18 15 // st RA
1021: CPi 18 620 // print_code
1022: BZJi 18 0 // print_code
1023: CPi 18 1206 // $RA.print_new_line
1024: CPi 15 1028 // retPC
1025: CPIi 18 15 // st RA
1026: CPi 18 756 // print_new_line
1027: BZJi 18 0 // print_new_line
1028: CP 14 1247 // $slot.main.1
1029: CP 15 3 // constant operand
1030: CP 16 15 // sub
1031: NAND 16 16 // ~
1032: ADDi 16 1 // -src
1033: ADD 14 16 // a-b
1034: CPi 18 1038 // condition fallthrough (P)
1035: BZJ 18 14 // condition fallthrough
1036: CPi 18 1168 // condition (P)
1037: BZJi 18 0 // condition
1038: CPi 14 2 // constant
1039: CP 1245 14 // spill val
1040: CP 14 1250 // $slot.main.4
1041: CP 18 14 // addr
1042: CP 14 1245 // reload val
1043: CPIi 18 14 // *=
1044: CP 14 1249 // $slot.main.3
1045: CPi 15 11 // constant operand
1046: ADD 14 15 // +
1047: CP 18 14
1048: CPI 14 18 // deref
1049: CPi 15 2 // constant operand
1050: CP 16 15 // sub
1051: NAND 16 16 // ~
1052: ADDi 16 1 // -src
1053: ADD 14 16 // a-b
1054: CPi 18 1058 // condition (P)
1055: BZJ 18 14 // condition
1056: CPi 18 1044 // wh loop
1057: BZJi 18 0 // loop
1058: CP 14 1249 // $slot.main.3
1059: CPi 15 10 // constant operand
1060: ADD 14 15 // +
1061: CP 18 14
1062: CPI 14 18 // deref
1063: CP 1248 14 // direct store
1064: CP 14 1248 // $slot.main.2
1065: CPi 18 1219 // $slot.score.0
1066: CPIi 18 14 // st param
1067: CP 14 1246 // $slot.main.0
1068: CPi 18 1220 // $slot.score.1
1069: CPIi 18 14 // st param
1070: CPi 18 1201 // $RA.score
1071: CPi 15 1075 // retPC
1072: CPIi 18 15 // st RA
1073: CPi 18 193 // score
1074: BZJi 18 0 // score
1075: CP 14 1198 // plus
1076: CPi 18 1242 // $slot.print_plus.0
1077: CPIi 18 14 // st param
1078: CPi 18 1208 // $RA.print_plus
1079: CPi 15 1083 // retPC
1080: CPIi 18 15 // st RA
1081: CPi 18 829 // print_plus
1082: BZJi 18 0 // print_plus
1083: CP 14 4 // constant
1084: CPi 18 1240 // $slot.print_space.0
1085: CPIi 18 14 // st param
1086: CPi 18 1207 // $RA.print_space
1087: CPi 15 1091 // retPC
1088: CPIi 18 15 // st RA
1089: CPi 18 803 // print_space
1090: BZJi 18 0 // print_space
1091: CP 14 1199 // minus
1092: CPi 18 1244 // $slot.print_minus.0
1093: CPIi 18 14 // st param
1094: CPi 18 1209 // $RA.print_minus
1095: CPi 15 1099 // retPC
1096: CPIi 18 15 // st RA
1097: CPi 18 878 // print_minus
1098: BZJi 18 0 // print_minus
1099: CP 14 4 // constant
1100: CPi 18 1240 // $slot.print_space.0
1101: CPIi 18 14 // st param
1102: CPi 18 1207 // $RA.print_space
1103: CPi 15 1107 // retPC
1104: CPIi 18 15 // st RA
1105: CPi 18 803 // print_space
1106: BZJi 18 0 // print_space
1107: CP 14 1248 // $slot.main.2
1108: CPi 18 1235 // $slot.print_code.0
1109: CPIi 18 14 // st param
1110: CPi 18 1205 // $RA.print_code
1111: CPi 15 1115 // retPC
1112: CPIi 18 15 // st RA
1113: CPi 18 620 // print_code
1114: BZJi 18 0 // print_code
1115: CPi 18 1206 // $RA.print_new_line
1116: CPi 15 1120 // retPC
1117: CPIi 18 15 // st RA
1118: CPi 18 756 // print_new_line
1119: BZJi 18 0 // print_new_line
1120: CP 14 1198 // plus
1121: CPi 15 4 // constant operand
1122: CP 16 15 // sub
1123: NAND 16 16 // ~
1124: ADDi 16 1 // -src
1125: ADD 14 16 // a-b
1126: CPi 18 1130 // condition fallthrough (P)
1127: BZJ 18 14 // condition fallthrough
1128: CPi 18 1131 // condition (P)
1129: BZJi 18 0 // condition
1130: CPi 1247 1 // direct assignment
1131: CP 14 1198 // plus
1132: SRLi 14 52 // <<
1133: CP 1245 14 // spill lhs
1134: CP 14 1199 // minus
1135: SRLi 14 48 // <<
1136: CP 15 14 // rhs
1137: CP 14 1245 // reload lhs
1138: CP 16 14 // or
1139: NAND 16 16 // ~a
1140: CP 17 15
1141: NAND 17 17 // ~b
1142: NAND 16 17 // a|b
1143: CP 14 16
1144: CP 15 1248 // $slot.main.2
1145: CP 16 14 // or
1146: NAND 16 16 // ~a
1147: CP 17 15
1148: NAND 17 17 // ~b
1149: NAND 16 17 // a|b
1150: CP 14 16
1151: CP 1245 14 // spill val
1152: CP 14 1249 // $slot.main.3
1153: CPi 15 10 // constant operand
1154: ADD 14 15 // +
1155: CP 18 14 // addr
1156: CP 14 1245 // reload val
1157: CPIi 18 14 // *=
1158: CP 14 4 // constant
1159: CP 1245 14 // spill val
1160: CP 14 1249 // $slot.main.3
1161: CPi 15 11 // constant operand
1162: ADD 14 15 // +
1163: CP 18 14 // addr
1164: CP 14 1245 // reload val
1165: CPIi 18 14 // *=
1166: CPi 18 1028 // wh loop
1167: BZJi 18 0 // loop
1168: CPi 14 5 // constant
1169: CP 1245 14 // spill val
1170: CP 14 1250 // $slot.main.4
1171: CP 18 14 // addr
1172: CP 14 1245 // reload val
1173: CPIi 18 14 // *=
1174: CPi 18 1204 // $RA.print_found
1175: CPi 15 1179 // retPC
1176: CPIi 18 15 // st RA
1177: CPi 18 510 // print_found
1178: BZJi 18 0 // print_found
1179: CPi 18 1206 // $RA.print_new_line
1180: CPi 15 1184 // retPC
1181: CPIi 18 15 // st RA
1182: CPi 18 756 // print_new_line
1183: BZJi 18 0 // print_new_line
1184: CPi 18 1203 // $RA.wait_for_tx_drain
1185: CPi 15 1189 // retPC
1186: CPIi 18 15 // st RA
1187: CPi 18 477 // wait_for_tx_drain
1188: BZJi 18 0 // wait_for_tx_drain
1189: CP 14 3 // constant
1190: CPi 18 1210 // $RA.main
1191: CPI 15 18 // load RA
1192: BZJi 15 0 // return
1193: CP 14 3 // ret 0
1194: CPi 18 1210 // $RA.main
1195: CPI 15 18 // load RA
1196: BZJi 15 0 // return
1197: BZJi 3 1197 // HALT
//$DATA_SECTION
1198: 0 // g'plus'
1199: 0 // g'minus'
1200: 0 // g'$RA.BCD_compare_digit'
1201: 0 // g'$RA.score'
1202: 0 // g'$RA.wait_tx'
1203: 0 // g'$RA.wait_for_tx_drain'
1204: 0 // g'$RA.print_found'
1205: 0 // g'$RA.print_code'
1206: 0 // g'$RA.print_new_line'
1207: 0 // g'$RA.print_space'
1208: 0 // g'$RA.print_plus'
1209: 0 // g'$RA.print_minus'
1210: 0 // g'$RA.main'
1211: 0 // g'$spill.BCD_compare_digit'[0]
1212: 0 // g'$spill.BCD_compare_digit'[1]
1213: 0 // g'$slot.BCD_compare_digit.0'
1214: 0 // g'$slot.BCD_compare_digit.1'
1215: 0 // g'$slot.BCD_compare_digit.2'
1216: 0 // g'$slot.BCD_compare_digit.3'
1217: 0 // g'$slot.BCD_compare_digit.4'
1218: 0 // g'$spill.score'
1219: 0 // g'$slot.score.0'
1220: 0 // g'$slot.score.1'
1221: 0 // g'$slot.score.2'
1222: 0 // g'$slot.score.3'
1223: 0 // g'$slot.score.4'
1224: 0 // g'$slot.score.5'
1225: 0 // g'$slot.score.6'
1226: 0 // g'$slot.score.7'
1227: 0 // g'$slot.score.8'
1228: 0 // g'$slot.wait_tx.0'
1229: 0 // g'$slot.wait_tx.1'
1230: 0 // g'$slot.wait_for_tx_drain.0'
1231: 0 // g'$slot.wait_for_tx_drain.1'
1232: 0 // g'$spill.print_found'
1233: 0 // g'$slot.print_found.0'
1234: 0 // g'$spill.print_code'
1235: 0 // g'$slot.print_code.0'
1236: 0 // g'$slot.print_code.1'
1237: 0 // g'$spill.print_new_line'
1238: 0 // g'$slot.print_new_line.0'
1239: 0 // g'$spill.print_space'
1240: 0 // g'$slot.print_space.0'
1241: 0 // g'$spill.print_plus'
1242: 0 // g'$slot.print_plus.0'
1243: 0 // g'$spill.print_minus'
1244: 0 // g'$slot.print_minus.0'
1245: 0 // g'$spill.main'
1246: 0 // g'$slot.main.0'
1247: 0 // g'$slot.main.1'
1248: 0 // g'$slot.main.2'
1249: 0 // g'$slot.main.3'
1250: 0 // g'$slot.main.4'
1251: 0 // g'$slot.main.5'
1252: 0 // g'$slot.main.6'
//$STACK_SECTION // none (stackless calling convention)
