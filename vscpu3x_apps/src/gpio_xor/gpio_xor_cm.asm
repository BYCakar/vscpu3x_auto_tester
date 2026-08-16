0: BZJi 3 20 // Goto init
//$REGISTERS_SECTION
1: 0 // SP (unused - stackless, no expression spills)
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
21: CPi 18 244 // $RA.main addr
22: CPi 15 243 // HALT addr
23: CPIi 18 15 // RA.main = HALT
24: BZJi 3 25 // Goto main
25: CPi 14 682 // 682
26: CPi 18 245 // $slot.main.0
27: CPIi 18 14 // $slot.main.0
28: CP 14 3 // 0
29: CPi 18 246 // $slot.main.1
30: CPIi 18 14 // $slot.main.1
31: CP 14 3 // 0
32: CPi 18 247 // $slot.main.2
33: CPIi 18 14 // $slot.main.2
34: CP 14 3 // 0
35: CPi 18 248 // $slot.main.3
36: CPIi 18 14 // $slot.main.3
37: CP 14 3 // 0
38: CPi 18 249 // $slot.main.4
39: CPIi 18 14 // $slot.main.4
40: CP 14 3 // 0
41: CPIi 1 14 // push val
42: ADDi 1 1 // SP++
43: CPi 14 8254 // 8254
44: CP 18 14 // addr
45: ADD 1 5 // SP--
46: CPI 14 1 // pop val
47: CPIi 18 14 // *=
48: CPi 18 249 // $slot.main.4
49: CPI 14 18 // $slot.main.4
50: CPi 15 8 // imm
51: LT 14 15 // <
52: CPi 18 188 // wh exit (P)
53: BZJ 18 14 // wh exit
54: CPi 14 8255 // 8255
55: CP 18 14
56: CPI 14 18 // deref
57: CPIi 1 14 // push lhs
58: ADDi 1 1 // SP++
59: CPi 14 1024 // 1024
60: CP 15 14 // rhs
61: ADD 1 5 // SP--
62: CPI 14 1 // pop lhs
63: NAND 14 15 // nand
64: NAND 14 14 // and
65: CPIi 1 14 // push lhs
66: ADDi 1 1 // SP++
67: CP 14 3 // 0
68: CP 15 14 // rhs
69: ADD 1 5 // SP--
70: CPI 14 1 // pop lhs
71: CP 16 15 // sub
72: NAND 16 16 // ~
73: ADDi 16 1 // -src
74: ADD 14 16 // a-b
75: CPi 18 80 // eq (P)
76: BZJ 18 14 // eq
77: CPi 14 0 // ne
78: CPi 18 81 // eq end (P)
79: BZJi 18 0 // eq end
80: CPi 14 1 // eq
81: CPi 18 85 // wh exit (P)
82: BZJ 18 14 // wh exit
83: CPi 18 54 // wh loop
84: BZJi 18 0 // loop
85: CPi 14 8255 // 8255
86: CP 18 14
87: CPI 14 18 // deref
88: CPi 18 246 // $slot.main.1
89: CPIi 18 14 // $slot.main.1
90: CPi 18 246 // $slot.main.1
91: CPI 14 18 // $slot.main.1
92: CPi 15 1023 // imm
93: NAND 14 15 // nand
94: NAND 14 14 // and
95: CPi 18 247 // $slot.main.2
96: CPIi 18 14 // $slot.main.2
97: CPi 18 247 // $slot.main.2
98: CPI 14 18 // $slot.main.2
99: CPi 18 245 // $slot.main.0
100: CPI 15 18 // $slot.main.0
101: CP 16 14 // xor
102: NAND 16 15 // C
103: CP 17 14 // a
104: NAND 17 16 // na
105: CP 14 15 // b
106: NAND 14 16 // nb
107: NAND 17 14 // xor
108: CP 14 17
109: CPIi 1 14 // push lhs
110: ADDi 1 1 // SP++
111: CPi 14 1023 // 1023
112: CP 15 14 // rhs
113: ADD 1 5 // SP--
114: CPI 14 1 // pop lhs
115: NAND 14 15 // nand
116: NAND 14 14 // and
117: CPi 18 248 // $slot.main.3
118: CPIi 18 14 // $slot.main.3
119: CPi 18 248 // $slot.main.3
120: CPI 14 18 // $slot.main.3
121: CPi 18 245 // $slot.main.0
122: CPIi 18 14 // $slot.main.0
123: CPi 18 248 // $slot.main.3
124: CPI 14 18 // $slot.main.3
125: CPi 15 1024 // imm
126: CP 16 14 // or
127: NAND 16 16 // ~a
128: CP 17 15
129: NAND 17 17 // ~b
130: NAND 16 17 // a|b
131: CP 14 16
132: CPIi 1 14 // push val
133: ADDi 1 1 // SP++
134: CPi 14 8254 // 8254
135: CP 18 14 // addr
136: ADD 1 5 // SP--
137: CPI 14 1 // pop val
138: CPIi 18 14 // *=
139: CPi 14 8255 // 8255
140: CP 18 14
141: CPI 14 18 // deref
142: CPIi 1 14 // push lhs
143: ADDi 1 1 // SP++
144: CPi 14 1024 // 1024
145: CP 15 14 // rhs
146: ADD 1 5 // SP--
147: CPI 14 1 // pop lhs
148: NAND 14 15 // nand
149: NAND 14 14 // and
150: CPIi 1 14 // push lhs
151: ADDi 1 1 // SP++
152: CP 14 3 // 0
153: CP 15 14 // rhs
154: ADD 1 5 // SP--
155: CPI 14 1 // pop lhs
156: CP 16 15 // sub
157: NAND 16 16 // ~
158: ADDi 16 1 // -src
159: ADD 14 16 // a-b
160: CPi 18 165 // ne? (P)
161: BZJ 18 14 // ne?
162: CP 14 5 // ne->-1
163: CPi 18 166 // ne end (P)
164: BZJi 18 0 // ne end
165: CPi 14 0 // eq->0
166: CPi 18 170 // wh exit (P)
167: BZJ 18 14 // wh exit
168: CPi 18 139 // wh loop
169: BZJi 18 0 // loop
170: CPi 18 248 // $slot.main.3
171: CPI 14 18 // $slot.main.3
172: CPIi 1 14 // push val
173: ADDi 1 1 // SP++
174: CPi 14 8254 // 8254
175: CP 18 14 // addr
176: ADD 1 5 // SP--
177: CPI 14 1 // pop val
178: CPIi 18 14 // *=
179: CPi 18 249 // $slot.main.4
180: CPI 14 18 // $slot.main.4
181: CP 15 14 // old
182: ADDi 14 1 // ++
183: CPi 18 249 // $slot.main.4
184: CPIi 18 14 // $slot.main.4
185: CP 14 15 // old
186: CPi 18 48 // wh loop
187: BZJi 18 0 // loop
188: CPi 14 8255 // 8255
189: CP 18 14
190: CPI 14 18 // deref
191: CPIi 1 14 // push lhs
192: ADDi 1 1 // SP++
193: CPi 14 1024 // 1024
194: CP 15 14 // rhs
195: ADD 1 5 // SP--
196: CPI 14 1 // pop lhs
197: NAND 14 15 // nand
198: NAND 14 14 // and
199: CPIi 1 14 // push lhs
200: ADDi 1 1 // SP++
201: CP 14 3 // 0
202: CP 15 14 // rhs
203: ADD 1 5 // SP--
204: CPI 14 1 // pop lhs
205: CP 16 15 // sub
206: NAND 16 16 // ~
207: ADDi 16 1 // -src
208: ADD 14 16 // a-b
209: CPi 18 214 // eq (P)
210: BZJ 18 14 // eq
211: CPi 14 0 // ne
212: CPi 18 215 // eq end (P)
213: BZJi 18 0 // eq end
214: CPi 14 1 // eq
215: CPi 18 219 // wh exit (P)
216: BZJ 18 14 // wh exit
217: CPi 18 188 // wh loop
218: BZJi 18 0 // loop
219: CPi 18 248 // $slot.main.3
220: CPI 14 18 // $slot.main.3
221: CPi 15 1024 // imm
222: CP 16 14 // or
223: NAND 16 16 // ~a
224: CP 17 15
225: NAND 17 17 // ~b
226: NAND 16 17 // a|b
227: CP 14 16
228: CPIi 1 14 // push val
229: ADDi 1 1 // SP++
230: CPi 14 8254 // 8254
231: CP 18 14 // addr
232: ADD 1 5 // SP--
233: CPI 14 1 // pop val
234: CPIi 18 14 // *=
235: CP 14 3 // 0
236: CPi 18 244 // $RA.main
237: CPI 15 18 // load RA
238: BZJi 15 0 // return
239: CP 14 3 // ret 0
240: CPi 18 244 // $RA.main
241: CPI 15 18 // load RA
242: BZJi 15 0 // return
243: BZJi 3 243 // HALT
//$DATA_SECTION
244: 0 // g'$RA.main'
245: 0 // g'$slot.main.0'
246: 0 // g'$slot.main.1'
247: 0 // g'$slot.main.2'
248: 0 // g'$slot.main.3'
249: 0 // g'$slot.main.4'
//$STACK_SECTION // none (stackless calling convention)
