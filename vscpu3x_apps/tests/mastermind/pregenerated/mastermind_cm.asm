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
24: BZJi 3 932 // Goto main
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
616: CPi 18 1203 // $RA.wait_for_tx_drain
617: CPi 15 621 // retPC
618: CPIi 18 15 // st RA
619: CPi 18 477 // wait_for_tx_drain
620: BZJi 18 0 // wait_for_tx_drain
621: CP 14 3 // ret 0
622: CPi 18 1204 // $RA.print_found
623: CPI 15 18 // load RA
624: BZJi 15 0 // return
625: CPi 1236 8448 // init local
626: CPi 18 1202 // $RA.wait_tx
627: CPi 15 631 // retPC
628: CPIi 18 15 // st RA
629: CPi 18 438 // wait_tx
630: BZJi 18 0 // wait_tx
631: CP 14 1235 // $slot.print_code.0
632: CP 16 14 // shift sign
633: SRLi 16 31 // negative?
634: CPi 18 641 // nonnegative shift (P)
635: BZJ 18 16 // nonnegative shift
636: NAND 14 14 // ~negative
637: SRLi 14 12 // >>
638: NAND 14 14 // sign extension
639: CPi 18 642 // shift end (P)
640: BZJi 18 0 // shift end
641: SRLi 14 12 // >>
642: CPi 15 48 // constant operand
643: ADD 14 15 // +
644: CP 1234 14 // spill val
645: CP 14 1236 // $slot.print_code.1
646: CPi 15 3 // constant operand
647: ADD 14 15 // +
648: CP 18 14 // addr
649: CP 14 1234 // reload val
650: CPIi 18 14 // *=
651: CP 14 4 // constant
652: CP 1234 14 // spill val
653: CP 14 1236 // $slot.print_code.1
654: CPi 15 4 // constant operand
655: ADD 14 15 // +
656: CP 18 14 // addr
657: CP 14 1234 // reload val
658: CPIi 18 14 // *=
659: CPi 18 1202 // $RA.wait_tx
660: CPi 15 664 // retPC
661: CPIi 18 15 // st RA
662: CPi 18 438 // wait_tx
663: BZJi 18 0 // wait_tx
664: CP 14 1235 // $slot.print_code.0
665: CP 16 14 // shift sign
666: SRLi 16 31 // negative?
667: CPi 18 674 // nonnegative shift (P)
668: BZJ 18 16 // nonnegative shift
669: NAND 14 14 // ~negative
670: SRLi 14 8 // >>
671: NAND 14 14 // sign extension
672: CPi 18 675 // shift end (P)
673: BZJi 18 0 // shift end
674: SRLi 14 8 // >>
675: CPi 15 15 // constant operand
676: NAND 14 15 // nand
677: NAND 14 14 // and
678: CPi 15 48 // constant operand
679: ADD 14 15 // +
680: CP 1234 14 // spill val
681: CP 14 1236 // $slot.print_code.1
682: CPi 15 3 // constant operand
683: ADD 14 15 // +
684: CP 18 14 // addr
685: CP 14 1234 // reload val
686: CPIi 18 14 // *=
687: CP 14 4 // constant
688: CP 1234 14 // spill val
689: CP 14 1236 // $slot.print_code.1
690: CPi 15 4 // constant operand
691: ADD 14 15 // +
692: CP 18 14 // addr
693: CP 14 1234 // reload val
694: CPIi 18 14 // *=
695: CPi 18 1202 // $RA.wait_tx
696: CPi 15 700 // retPC
697: CPIi 18 15 // st RA
698: CPi 18 438 // wait_tx
699: BZJi 18 0 // wait_tx
700: CP 14 1235 // $slot.print_code.0
701: CP 16 14 // shift sign
702: SRLi 16 31 // negative?
703: CPi 18 710 // nonnegative shift (P)
704: BZJ 18 16 // nonnegative shift
705: NAND 14 14 // ~negative
706: SRLi 14 4 // >>
707: NAND 14 14 // sign extension
708: CPi 18 711 // shift end (P)
709: BZJi 18 0 // shift end
710: SRLi 14 4 // >>
711: CPi 15 15 // constant operand
712: NAND 14 15 // nand
713: NAND 14 14 // and
714: CPi 15 48 // constant operand
715: ADD 14 15 // +
716: CP 1234 14 // spill val
717: CP 14 1236 // $slot.print_code.1
718: CPi 15 3 // constant operand
719: ADD 14 15 // +
720: CP 18 14 // addr
721: CP 14 1234 // reload val
722: CPIi 18 14 // *=
723: CP 14 4 // constant
724: CP 1234 14 // spill val
725: CP 14 1236 // $slot.print_code.1
726: CPi 15 4 // constant operand
727: ADD 14 15 // +
728: CP 18 14 // addr
729: CP 14 1234 // reload val
730: CPIi 18 14 // *=
731: CPi 18 1202 // $RA.wait_tx
732: CPi 15 736 // retPC
733: CPIi 18 15 // st RA
734: CPi 18 438 // wait_tx
735: BZJi 18 0 // wait_tx
736: CP 14 1235 // $slot.print_code.0
737: CPi 15 15 // constant operand
738: NAND 14 15 // nand
739: NAND 14 14 // and
740: CPi 15 48 // constant operand
741: ADD 14 15 // +
742: CP 1234 14 // spill val
743: CP 14 1236 // $slot.print_code.1
744: CPi 15 3 // constant operand
745: ADD 14 15 // +
746: CP 18 14 // addr
747: CP 14 1234 // reload val
748: CPIi 18 14 // *=
749: CP 14 4 // constant
750: CP 1234 14 // spill val
751: CP 14 1236 // $slot.print_code.1
752: CPi 15 4 // constant operand
753: ADD 14 15 // +
754: CP 18 14 // addr
755: CP 14 1234 // reload val
756: CPIi 18 14 // *=
757: CP 14 3 // ret 0
758: CPi 18 1205 // $RA.print_code
759: CPI 15 18 // load RA
760: BZJi 15 0 // return
761: CPi 1238 8448 // init local
762: CPi 18 1202 // $RA.wait_tx
763: CPi 15 767 // retPC
764: CPIi 18 15 // st RA
765: CPi 18 438 // wait_tx
766: BZJi 18 0 // wait_tx
767: CPi 14 13 // constant
768: CP 1237 14 // spill val
769: CP 14 1238 // $slot.print_new_line.0
770: CPi 15 3 // constant operand
771: ADD 14 15 // +
772: CP 18 14 // addr
773: CP 14 1237 // reload val
774: CPIi 18 14 // *=
775: CP 14 4 // constant
776: CP 1237 14 // spill val
777: CP 14 1238 // $slot.print_new_line.0
778: CPi 15 4 // constant operand
779: ADD 14 15 // +
780: CP 18 14 // addr
781: CP 14 1237 // reload val
782: CPIi 18 14 // *=
783: CPi 18 1202 // $RA.wait_tx
784: CPi 15 788 // retPC
785: CPIi 18 15 // st RA
786: CPi 18 438 // wait_tx
787: BZJi 18 0 // wait_tx
788: CPi 14 10 // constant
789: CP 1237 14 // spill val
790: CP 14 1238 // $slot.print_new_line.0
791: CPi 15 3 // constant operand
792: ADD 14 15 // +
793: CP 18 14 // addr
794: CP 14 1237 // reload val
795: CPIi 18 14 // *=
796: CP 14 4 // constant
797: CP 1237 14 // spill val
798: CP 14 1238 // $slot.print_new_line.0
799: CPi 15 4 // constant operand
800: ADD 14 15 // +
801: CP 18 14 // addr
802: CP 14 1237 // reload val
803: CPIi 18 14 // *=
804: CP 14 3 // ret 0
805: CPi 18 1206 // $RA.print_new_line
806: CPI 15 18 // load RA
807: BZJi 15 0 // return
808: CPi 1240 8448 // init local
809: CPi 18 1202 // $RA.wait_tx
810: CPi 15 814 // retPC
811: CPIi 18 15 // st RA
812: CPi 18 438 // wait_tx
813: BZJi 18 0 // wait_tx
814: CPi 14 32 // constant
815: CP 1239 14 // spill val
816: CP 14 1240 // $slot.print_space.0
817: CPi 15 3 // constant operand
818: ADD 14 15 // +
819: CP 18 14 // addr
820: CP 14 1239 // reload val
821: CPIi 18 14 // *=
822: CP 14 4 // constant
823: CP 1239 14 // spill val
824: CP 14 1240 // $slot.print_space.0
825: CPi 15 4 // constant operand
826: ADD 14 15 // +
827: CP 18 14 // addr
828: CP 14 1239 // reload val
829: CPIi 18 14 // *=
830: CP 14 3 // ret 0
831: CPi 18 1207 // $RA.print_space
832: CPI 15 18 // load RA
833: BZJi 15 0 // return
834: CPi 1242 8448 // init local
835: CPi 18 1202 // $RA.wait_tx
836: CPi 15 840 // retPC
837: CPIi 18 15 // st RA
838: CPi 18 438 // wait_tx
839: BZJi 18 0 // wait_tx
840: CPi 14 43 // constant
841: CP 1241 14 // spill val
842: CP 14 1242 // $slot.print_plus.0
843: CPi 15 3 // constant operand
844: ADD 14 15 // +
845: CP 18 14 // addr
846: CP 14 1241 // reload val
847: CPIi 18 14 // *=
848: CP 14 4 // constant
849: CP 1241 14 // spill val
850: CP 14 1242 // $slot.print_plus.0
851: CPi 15 4 // constant operand
852: ADD 14 15 // +
853: CP 18 14 // addr
854: CP 14 1241 // reload val
855: CPIi 18 14 // *=
856: CPi 18 1202 // $RA.wait_tx
857: CPi 15 861 // retPC
858: CPIi 18 15 // st RA
859: CPi 18 438 // wait_tx
860: BZJi 18 0 // wait_tx
861: CPi 14 48 // constant
862: CP 15 1198 // plus
863: ADD 14 15 // +
864: CP 1241 14 // spill val
865: CP 14 1242 // $slot.print_plus.0
866: CPi 15 3 // constant operand
867: ADD 14 15 // +
868: CP 18 14 // addr
869: CP 14 1241 // reload val
870: CPIi 18 14 // *=
871: CP 14 4 // constant
872: CP 1241 14 // spill val
873: CP 14 1242 // $slot.print_plus.0
874: CPi 15 4 // constant operand
875: ADD 14 15 // +
876: CP 18 14 // addr
877: CP 14 1241 // reload val
878: CPIi 18 14 // *=
879: CP 14 3 // ret 0
880: CPi 18 1208 // $RA.print_plus
881: CPI 15 18 // load RA
882: BZJi 15 0 // return
883: CPi 1244 8448 // init local
884: CPi 18 1202 // $RA.wait_tx
885: CPi 15 889 // retPC
886: CPIi 18 15 // st RA
887: CPi 18 438 // wait_tx
888: BZJi 18 0 // wait_tx
889: CPi 14 45 // constant
890: CP 1243 14 // spill val
891: CP 14 1244 // $slot.print_minus.0
892: CPi 15 3 // constant operand
893: ADD 14 15 // +
894: CP 18 14 // addr
895: CP 14 1243 // reload val
896: CPIi 18 14 // *=
897: CP 14 4 // constant
898: CP 1243 14 // spill val
899: CP 14 1244 // $slot.print_minus.0
900: CPi 15 4 // constant operand
901: ADD 14 15 // +
902: CP 18 14 // addr
903: CP 14 1243 // reload val
904: CPIi 18 14 // *=
905: CPi 18 1202 // $RA.wait_tx
906: CPi 15 910 // retPC
907: CPIi 18 15 // st RA
908: CPi 18 438 // wait_tx
909: BZJi 18 0 // wait_tx
910: CPi 14 48 // constant
911: CP 15 1199 // minus
912: ADD 14 15 // +
913: CP 1243 14 // spill val
914: CP 14 1244 // $slot.print_minus.0
915: CPi 15 3 // constant operand
916: ADD 14 15 // +
917: CP 18 14 // addr
918: CP 14 1243 // reload val
919: CPIi 18 14 // *=
920: CP 14 4 // constant
921: CP 1243 14 // spill val
922: CP 14 1244 // $slot.print_minus.0
923: CPi 15 4 // constant operand
924: ADD 14 15 // +
925: CP 18 14 // addr
926: CP 14 1243 // reload val
927: CPIi 18 14 // *=
928: CP 14 3 // ret 0
929: CPi 18 1209 // $RA.print_minus
930: CPI 15 18 // load RA
931: BZJi 15 0 // return
932: CPi 14 1 // constant
933: SRLi 14 46 // <<14
934: ADDi 14 5461 // low
935: CP 1246 14 // $slot.main.0
936: CPi 1247 0 // init local
937: CPi 1248 0 // init local
938: CPi 1249 0 // init local
939: CPi 1249 8192 // init local
940: CPi 1250 8464 // init local
941: CPi 1251 8448 // init local
942: CPi 1252 0 // init local
943: CP 14 4 // constant
944: CP 1245 14 // spill val
945: CP 14 1249 // $slot.main.3
946: CPi 15 11 // constant operand
947: ADD 14 15 // +
948: CP 18 14 // addr
949: CP 14 1245 // reload val
950: CPIi 18 14 // *=
951: CP 14 4 // constant
952: CP 1245 14 // spill val
953: CP 14 1250 // $slot.main.4
954: CP 18 14 // addr
955: CP 14 1245 // reload val
956: CPIi 18 14 // *=
957: CPi 18 1202 // $RA.wait_tx
958: CPi 15 962 // retPC
959: CPIi 18 15 // st RA
960: CPi 18 438 // wait_tx
961: BZJi 18 0 // wait_tx
962: CPi 14 115 // constant
963: CP 1245 14 // spill val
964: CP 14 1251 // $slot.main.5
965: CPi 15 3 // constant operand
966: ADD 14 15 // +
967: CP 18 14 // addr
968: CP 14 1245 // reload val
969: CPIi 18 14 // *=
970: CP 14 4 // constant
971: CP 1245 14 // spill val
972: CP 14 1251 // $slot.main.5
973: CPi 15 4 // constant operand
974: ADD 14 15 // +
975: CP 18 14 // addr
976: CP 14 1245 // reload val
977: CPIi 18 14 // *=
978: CPi 18 1202 // $RA.wait_tx
979: CPi 15 983 // retPC
980: CPIi 18 15 // st RA
981: CPi 18 438 // wait_tx
982: BZJi 18 0 // wait_tx
983: CPi 14 99 // constant
984: CP 1245 14 // spill val
985: CP 14 1251 // $slot.main.5
986: CPi 15 3 // constant operand
987: ADD 14 15 // +
988: CP 18 14 // addr
989: CP 14 1245 // reload val
990: CPIi 18 14 // *=
991: CP 14 4 // constant
992: CP 1245 14 // spill val
993: CP 14 1251 // $slot.main.5
994: CPi 15 4 // constant operand
995: ADD 14 15 // +
996: CP 18 14 // addr
997: CP 14 1245 // reload val
998: CPIi 18 14 // *=
999: CPi 18 1202 // $RA.wait_tx
1000: CPi 15 1004 // retPC
1001: CPIi 18 15 // st RA
1002: CPi 18 438 // wait_tx
1003: BZJi 18 0 // wait_tx
1004: CPi 14 58 // constant
1005: CP 1245 14 // spill val
1006: CP 14 1251 // $slot.main.5
1007: CPi 15 3 // constant operand
1008: ADD 14 15 // +
1009: CP 18 14 // addr
1010: CP 14 1245 // reload val
1011: CPIi 18 14 // *=
1012: CP 14 4 // constant
1013: CP 1245 14 // spill val
1014: CP 14 1251 // $slot.main.5
1015: CPi 15 4 // constant operand
1016: ADD 14 15 // +
1017: CP 18 14 // addr
1018: CP 14 1245 // reload val
1019: CPIi 18 14 // *=
1020: CP 14 1246 // $slot.main.0
1021: CPi 18 1235 // $slot.print_code.0
1022: CPIi 18 14 // st param
1023: CPi 18 1205 // $RA.print_code
1024: CPi 15 1028 // retPC
1025: CPIi 18 15 // st RA
1026: CPi 18 625 // print_code
1027: BZJi 18 0 // print_code
1028: CPi 18 1206 // $RA.print_new_line
1029: CPi 15 1033 // retPC
1030: CPIi 18 15 // st RA
1031: CPi 18 761 // print_new_line
1032: BZJi 18 0 // print_new_line
1033: CP 14 1247 // $slot.main.1
1034: CP 15 3 // constant operand
1035: CP 16 15 // sub
1036: NAND 16 16 // ~
1037: ADDi 16 1 // -src
1038: ADD 14 16 // a-b
1039: CPi 18 1043 // condition fallthrough (P)
1040: BZJ 18 14 // condition fallthrough
1041: CPi 18 1173 // condition (P)
1042: BZJi 18 0 // condition
1043: CPi 14 2 // constant
1044: CP 1245 14 // spill val
1045: CP 14 1250 // $slot.main.4
1046: CP 18 14 // addr
1047: CP 14 1245 // reload val
1048: CPIi 18 14 // *=
1049: CP 14 1249 // $slot.main.3
1050: CPi 15 11 // constant operand
1051: ADD 14 15 // +
1052: CP 18 14
1053: CPI 14 18 // deref
1054: CPi 15 2 // constant operand
1055: CP 16 15 // sub
1056: NAND 16 16 // ~
1057: ADDi 16 1 // -src
1058: ADD 14 16 // a-b
1059: CPi 18 1063 // condition (P)
1060: BZJ 18 14 // condition
1061: CPi 18 1049 // wh loop
1062: BZJi 18 0 // loop
1063: CP 14 1249 // $slot.main.3
1064: CPi 15 10 // constant operand
1065: ADD 14 15 // +
1066: CP 18 14
1067: CPI 14 18 // deref
1068: CP 1248 14 // direct store
1069: CP 14 1248 // $slot.main.2
1070: CPi 18 1219 // $slot.score.0
1071: CPIi 18 14 // st param
1072: CP 14 1246 // $slot.main.0
1073: CPi 18 1220 // $slot.score.1
1074: CPIi 18 14 // st param
1075: CPi 18 1201 // $RA.score
1076: CPi 15 1080 // retPC
1077: CPIi 18 15 // st RA
1078: CPi 18 193 // score
1079: BZJi 18 0 // score
1080: CP 14 1198 // plus
1081: CPi 18 1242 // $slot.print_plus.0
1082: CPIi 18 14 // st param
1083: CPi 18 1208 // $RA.print_plus
1084: CPi 15 1088 // retPC
1085: CPIi 18 15 // st RA
1086: CPi 18 834 // print_plus
1087: BZJi 18 0 // print_plus
1088: CP 14 4 // constant
1089: CPi 18 1240 // $slot.print_space.0
1090: CPIi 18 14 // st param
1091: CPi 18 1207 // $RA.print_space
1092: CPi 15 1096 // retPC
1093: CPIi 18 15 // st RA
1094: CPi 18 808 // print_space
1095: BZJi 18 0 // print_space
1096: CP 14 1199 // minus
1097: CPi 18 1244 // $slot.print_minus.0
1098: CPIi 18 14 // st param
1099: CPi 18 1209 // $RA.print_minus
1100: CPi 15 1104 // retPC
1101: CPIi 18 15 // st RA
1102: CPi 18 883 // print_minus
1103: BZJi 18 0 // print_minus
1104: CP 14 4 // constant
1105: CPi 18 1240 // $slot.print_space.0
1106: CPIi 18 14 // st param
1107: CPi 18 1207 // $RA.print_space
1108: CPi 15 1112 // retPC
1109: CPIi 18 15 // st RA
1110: CPi 18 808 // print_space
1111: BZJi 18 0 // print_space
1112: CP 14 1248 // $slot.main.2
1113: CPi 18 1235 // $slot.print_code.0
1114: CPIi 18 14 // st param
1115: CPi 18 1205 // $RA.print_code
1116: CPi 15 1120 // retPC
1117: CPIi 18 15 // st RA
1118: CPi 18 625 // print_code
1119: BZJi 18 0 // print_code
1120: CPi 18 1206 // $RA.print_new_line
1121: CPi 15 1125 // retPC
1122: CPIi 18 15 // st RA
1123: CPi 18 761 // print_new_line
1124: BZJi 18 0 // print_new_line
1125: CP 14 1198 // plus
1126: CPi 15 4 // constant operand
1127: CP 16 15 // sub
1128: NAND 16 16 // ~
1129: ADDi 16 1 // -src
1130: ADD 14 16 // a-b
1131: CPi 18 1135 // condition fallthrough (P)
1132: BZJ 18 14 // condition fallthrough
1133: CPi 18 1136 // condition (P)
1134: BZJi 18 0 // condition
1135: CPi 1247 1 // direct assignment
1136: CP 14 1198 // plus
1137: SRLi 14 52 // <<
1138: CP 1245 14 // spill lhs
1139: CP 14 1199 // minus
1140: SRLi 14 48 // <<
1141: CP 15 14 // rhs
1142: CP 14 1245 // reload lhs
1143: CP 16 14 // or
1144: NAND 16 16 // ~a
1145: CP 17 15
1146: NAND 17 17 // ~b
1147: NAND 16 17 // a|b
1148: CP 14 16
1149: CP 15 1248 // $slot.main.2
1150: CP 16 14 // or
1151: NAND 16 16 // ~a
1152: CP 17 15
1153: NAND 17 17 // ~b
1154: NAND 16 17 // a|b
1155: CP 14 16
1156: CP 1245 14 // spill val
1157: CP 14 1249 // $slot.main.3
1158: CPi 15 10 // constant operand
1159: ADD 14 15 // +
1160: CP 18 14 // addr
1161: CP 14 1245 // reload val
1162: CPIi 18 14 // *=
1163: CP 14 4 // constant
1164: CP 1245 14 // spill val
1165: CP 14 1249 // $slot.main.3
1166: CPi 15 11 // constant operand
1167: ADD 14 15 // +
1168: CP 18 14 // addr
1169: CP 14 1245 // reload val
1170: CPIi 18 14 // *=
1171: CPi 18 1033 // wh loop
1172: BZJi 18 0 // loop
1173: CPi 14 5 // constant
1174: CP 1245 14 // spill val
1175: CP 14 1250 // $slot.main.4
1176: CP 18 14 // addr
1177: CP 14 1245 // reload val
1178: CPIi 18 14 // *=
1179: CPi 18 1204 // $RA.print_found
1180: CPi 15 1184 // retPC
1181: CPIi 18 15 // st RA
1182: CPi 18 510 // print_found
1183: BZJi 18 0 // print_found
1184: CPi 18 1206 // $RA.print_new_line
1185: CPi 15 1189 // retPC
1186: CPIi 18 15 // st RA
1187: CPi 18 761 // print_new_line
1188: BZJi 18 0 // print_new_line
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
