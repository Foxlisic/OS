; ---------------------------------------
; Установка стандартной палитры (8 бит) 256 цветов
; ---------------------------------------
set_palette_256:

	mov ecx, 256
	jmp set_palette_16.begin
	
; ---------------------------------------
; Установка стандартной палитры (4 бит)
; ---------------------------------------
set_palette_16:

	; Просто 16 цветов
	mov ecx, 16
	
.begin:

	mov ebx, 0
	mov esi, .pal16
	
@@:	; for (ebx = 0; ebx < 16; ebx++) 
	lodsd
	
	; eax = pal16[ebx]
	invk2 DAC_set, ebx, eax
	inc ebx
	loop @b
	ret

; Цветовая палитра 16-битного режима
.pal16:

	dd 0x000000 ; 0 blue
	dd 0x000080 ; 1 red
	dd 0x008000 ; 2 green
	dd 0x008080 ; 3 cyan
	dd 0x800000 ; 4 red
	dd 0x800080 ; 5 purple
	dd 0x808000 ; 6 dark yellow
	dd 0xC0C0C0 ; 7 gray
	dd 0x808080 ; 8 dark gray
	dd 0x0000FF ; 9 
	dd 0x00FF00 ; 10
	dd 0x00FFFF ; 11
	dd 0xFF0000 ; 12	
	dd 0xFF00FF ; 13
	dd 0xFFFF00 ; 14
	dd 0xFFFFFF ; 15
	
.pal256_ext:
	
	dd 0x00000000 ; 16
	dd 0x00141414 ; 17
	dd 0x00202020 ; 18
	dd 0x002c2c2c ; 19
	dd 0x00383838 ; 20
	dd 0x00444444 ; 21
	dd 0x00505050 ; 22
	dd 0x00606060 ; 23
	dd 0x00707070 ; 24
	dd 0x00808080 ; 25
	dd 0x00909090 ; 26
	dd 0x00a0a0a0 ; 27
	dd 0x00b4b4b4 ; 28
	dd 0x00c8c8c8 ; 29
	dd 0x00e0e0e0 ; 30
	dd 0x00fcfcfc ; 31
	dd 0x00fc0000 ; 32
	dd 0x00fc0040 ; 33
	dd 0x00fc007c ; 34
	dd 0x00fc00bc ; 35
	dd 0x00fc00fc ; 36
	dd 0x00bc00fc ; 37
	dd 0x007c00fc ; 38
	dd 0x004000fc ; 39
	dd 0x000000fc ; 40
	dd 0x000040fc ; 41
	dd 0x00007cfc ; 42
	dd 0x0000bcfc ; 43
	dd 0x0000fcfc ; 44
	dd 0x0000fcbc ; 45
	dd 0x0000fc7c ; 46
	dd 0x0000fc40 ; 47
	dd 0x0000fc00 ; 48
	dd 0x0040fc00 ; 49
	dd 0x007cfc00 ; 50
	dd 0x00bcfc00 ; 51
	dd 0x00fcfc00 ; 52
	dd 0x00fcbc00 ; 53
	dd 0x00fc7c00 ; 54
	dd 0x00fc4000 ; 55
	dd 0x00fc7c7c ; 56
	dd 0x00fc7c9c ; 57
	dd 0x00fc7cbc ; 58
	dd 0x00fc7cdc ; 59
	dd 0x00fc7cfc ; 60
	dd 0x00dc7cfc ; 61
	dd 0x00bc7cfc ; 62
	dd 0x009c7cfc ; 63
	dd 0x007c7cfc ; 64
	dd 0x007c9cfc ; 65
	dd 0x007cbcfc ; 66
	dd 0x007cdcfc ; 67
	dd 0x007cfcfc ; 68
	dd 0x007cfcdc ; 69
	dd 0x007cfcbc ; 70
	dd 0x007cfc9c ; 71
	dd 0x007cfc7c ; 72
	dd 0x009cfc7c ; 73
	dd 0x00bcfc7c ; 74
	dd 0x00dcfc7c ; 75
	dd 0x00fcfc7c ; 76
	dd 0x00fcdc7c ; 77
	dd 0x00fcbc7c ; 78
	dd 0x00fc9c7c ; 79
	dd 0x00fcb4b4 ; 80
	dd 0x00fcb4c4 ; 81
	dd 0x00fcb4d8 ; 82
	dd 0x00fcb4e8 ; 83
	dd 0x00fcb4fc ; 84
	dd 0x00e8b4fc ; 85
	dd 0x00d8b4fc ; 86
	dd 0x00c4b4fc ; 87
	dd 0x00b4b4fc ; 88
	dd 0x00b4c4fc ; 89
	dd 0x00b4d8fc ; 90
	dd 0x00b4e8fc ; 91
	dd 0x00b4fcfc ; 92
	dd 0x00b4fce8 ; 93
	dd 0x00b4fcd8 ; 94
	dd 0x00b4fcc4 ; 95
	dd 0x00b4fcb4 ; 96
	dd 0x00c4fcb4 ; 97
	dd 0x00d8fcb4 ; 98
	dd 0x00e8fcb4 ; 99
	dd 0x00fcfcb4 ; 100
	dd 0x00fce8b4 ; 101
	dd 0x00fcd8b4 ; 102
	dd 0x00fcc4b4 ; 103
	dd 0x00700000 ; 104
	dd 0x0070001c ; 105
	dd 0x00700038 ; 106
	dd 0x00700054 ; 107
	dd 0x00700070 ; 108
	dd 0x00540070 ; 109
	dd 0x00380070 ; 110
	dd 0x001c0070 ; 111
	dd 0x00000070 ; 112
	dd 0x00001c70 ; 113
	dd 0x00003870 ; 114
	dd 0x00005470 ; 115
	dd 0x00007070 ; 116
	dd 0x00007054 ; 117
	dd 0x00007038 ; 118
	dd 0x0000701c ; 119
	dd 0x00007000 ; 120
	dd 0x001c7000 ; 121
	dd 0x00387000 ; 122
	dd 0x00547000 ; 123
	dd 0x00707000 ; 124
	dd 0x00705400 ; 125
	dd 0x00703800 ; 126
	dd 0x00701c00 ; 127
	dd 0x00703838 ; 128
	dd 0x00703844 ; 129
	dd 0x00703854 ; 130
	dd 0x00703860 ; 131
	dd 0x00703870 ; 132
	dd 0x00603870 ; 133
	dd 0x00543870 ; 134
	dd 0x00443870 ; 135
	dd 0x00383870 ; 136
	dd 0x00384470 ; 137
	dd 0x00385470 ; 138
	dd 0x00386070 ; 139
	dd 0x00387070 ; 140
	dd 0x00387060 ; 141
	dd 0x00387054 ; 142
	dd 0x00387044 ; 143
	dd 0x00387038 ; 144
	dd 0x00447038 ; 145
	dd 0x00547038 ; 146
	dd 0x00607038 ; 147
	dd 0x00707038 ; 148
	dd 0x00706038 ; 149
	dd 0x00705438 ; 150
	dd 0x00704438 ; 151
	dd 0x00705050 ; 152
	dd 0x00705058 ; 153
	dd 0x00705060 ; 154
	dd 0x00705068 ; 155
	dd 0x00705070 ; 156
	dd 0x00685070 ; 157
	dd 0x00605070 ; 158
	dd 0x00585070 ; 159
	dd 0x00505070 ; 160
	dd 0x00505870 ; 161
	dd 0x00506070 ; 162
	dd 0x00506870 ; 163
	dd 0x00507070 ; 164
	dd 0x00507068 ; 165
	dd 0x00507060 ; 166
	dd 0x00507058 ; 167
	dd 0x00507050 ; 168
	dd 0x00587050 ; 169
	dd 0x00607050 ; 170
	dd 0x00687050 ; 171
	dd 0x00707050 ; 172
	dd 0x00706850 ; 173
	dd 0x00706050 ; 174
	dd 0x00705850 ; 175
	dd 0x00400000 ; 176
	dd 0x00400010 ; 177
	dd 0x00400020 ; 178
	dd 0x00400030 ; 179
	dd 0x00400040 ; 180
	dd 0x00300040 ; 181
	dd 0x00200040 ; 182
	dd 0x00100040 ; 183
	dd 0x00000040 ; 184
	dd 0x00001040 ; 185
	dd 0x00002040 ; 186
	dd 0x00003040 ; 187
	dd 0x00004040 ; 188
	dd 0x00004030 ; 189
	dd 0x00004020 ; 190
	dd 0x00004010 ; 191
	dd 0x00004000 ; 192
	dd 0x00104000 ; 193
	dd 0x00204000 ; 194
	dd 0x00304000 ; 195
	dd 0x00404000 ; 196
	dd 0x00403000 ; 197
	dd 0x00402000 ; 198
	dd 0x00401000 ; 199
	dd 0x00402020 ; 200
	dd 0x00402028 ; 201
	dd 0x00402030 ; 202
	dd 0x00402038 ; 203
	dd 0x00402040 ; 204
	dd 0x00382040 ; 205
	dd 0x00302040 ; 206
	dd 0x00282040 ; 207
	dd 0x00202040 ; 208
	dd 0x00202840 ; 209
	dd 0x00203040 ; 210
	dd 0x00203840 ; 211
	dd 0x00204040 ; 212
	dd 0x00204038 ; 213
	dd 0x00204030 ; 214
	dd 0x00204028 ; 215
	dd 0x00204020 ; 216
	dd 0x00284020 ; 217
	dd 0x00304020 ; 218
	dd 0x00384020 ; 219
	dd 0x00404020 ; 220
	dd 0x00403820 ; 221
	dd 0x00403020 ; 222
	dd 0x00402820 ; 223
	dd 0x00402c2c ; 224
	dd 0x00402c30 ; 225
	dd 0x00402c34 ; 226
	dd 0x00402c3c ; 227
	dd 0x00402c40 ; 228
	dd 0x003c2c40 ; 229
	dd 0x00342c40 ; 230
	dd 0x00302c40 ; 231
	dd 0x002c2c40 ; 232
	dd 0x002c3040 ; 233
	dd 0x002c3440 ; 234
	dd 0x002c3c40 ; 235
	dd 0x002c4040 ; 236
	dd 0x002c403c ; 237
	dd 0x002c4034 ; 238
	dd 0x002c4030 ; 239
	dd 0x002c402c ; 240
	dd 0x0030402c ; 241
	dd 0x0034402c ; 242
	dd 0x003c402c ; 243
	dd 0x0040402c ; 244
	dd 0x00403c2c ; 245
	dd 0x0040342c ; 246
	dd 0x0040302c ; 247
	dd 0x00000000 ; 248
	dd 0x00000000 ; 249
	dd 0x00000000 ; 250
	dd 0x00000000 ; 251
	dd 0x00000000 ; 252
	dd 0x00000000 ; 253
	dd 0x00000000 ; 254
	dd 0x00000000 ; 255
