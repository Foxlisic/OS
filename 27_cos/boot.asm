		
		macro	brk { xchg bx, bx }
		org		7c00h
		
		jmp		near start

; ----------------------------------------------------------------------
; BPB: Bios Parameter Block		
; ----------------------------------------------------------------------
		db		"FLOPPY12"			; 03 Signature
		dw		200h				; 0B Bytes in sector
		db		1					; 0D Sectors by cluster
		dw      1					; 0E Count reserver sectors
		db		2					; 10 Count of FAT
		dw		00E0h				; 11 Count of Root Entries (224)
		dw		0B40h				; 13 Total count of sectors
		db		0F0h				; 15 Media
		dw		9					; 16 Sectors in FAT
		dw		12h					; 18 Sectors on track
		dw		2					; 1A Count of heads
		dd		0					; 1C Hidden Sectors (large)
		dd		0					; 20 Total Sectors
		db		0					; 24 Number of Phys.
		db		1					; 25 Flags
		db		29h					; 26 Ext Sig
		dd		07E00000h			; 27 Serial Numbers ES:BX
		db		'MAIN    BIN'		; 2B Label / Exec File
		db		'FAT12    '			; 36 Type of FS
; ----------------------------------------------------------------------

start:

		cli
		cld
		mov		sp, 7c00h
		mov		ax, 19
dir:	les		bx, [7c27h]
		call	ReadSector
		mov		di, bx
		mov		bp, 16
item:	mov		si, 7c2bh		; ds:si - label filename
		mov		cx, 12			; 11 + 1
		push	di
		repe	cmpsb			; compare string
		pop		di
		jcxz	file_found
		add		di, 32
		dec		bp
		jne		item
		inc		ax
		sub		word [7c11h], 16
		jne		dir
		int		18h
		
; ----------------------------------------------------------------------
; Loading file from FS
; ----------------------------------------------------------------------

file_found:		

		mov		ax, [es: di + 1Ah]
		mov		[7c22h], word 800h		; address of write program
		
next:	push	ax
		add		ax, 31
		les		bx, [7c20h]
		call	ReadSector		
		add		[7c22h], word 20h
		pop		ax
		
		mov		bx, 3
		mul		bx		
		push	ax
		shr		ax, 1 + 9
		inc		ax				; +1 bpb
		mov		si, ax
		les		bx, [7c27h]		; es:bx=07e0:0000
		call	ReadSector
		pop		ax
		
		mov		bp, ax
		mov		di, ax
		shr		di, 1
		and		di, 0x1FF
		mov		ax, [es: di]	; 07e0
		cmp		di, 0x1FF
		jne		@f
		push	ax
		xchg	ax, si
		inc		ax
		call	ReadSector
		pop		ax
		mov		ah, [es: bx]
@@:		test	bp, 1
		jz		@f
		shr		ax, 4
@@:		and		ax, 0x0FFF			; 12
		cmp		ax, 0x0FF0
		jb		next

; ----------------------------------------------------------------------
; Init protected
; ----------------------------------------------------------------------

		mov		ax, 0012h			; text 80x25; vga 640x480
		int		10h
		
		lgdt	[GDTR]
		lidt	[IDTR]
		
		mov		eax, cr0
		or		al, 1
		mov		cr0, eax
		jmp		10h : pm

; ----------------------------------------------------------------------
; AX - number of sector, ES:BX pointer to data place
; ----------------------------------------------------------------------

ReadSector:

		push	ax
		mov		cx, 12h
		cwd
		div		cx
		xchg	ax, cx
		mov		dh, cl
		and		dh, 1
		shr		cx, 1
		xchg	ch, cl
		shr		cl, 6
		inc		dx
		or		cl, dl			
		mov		dl, 0
		mov		ax, 0201h
		int		13h				; es:bx, cx/dx
		pop		ax
		ret

; ----------------------------------------------------------------------
; GDT/IDT Descriptors
; ----------------------------------------------------------------------

GDTR:	dw		3*8-1
		dd		GDT
IDTR:	dw		256*8-1
		dd		0
GDT:	dw		0,		0,		0,		0
		dw		0FFFFh, 0,	9200h,  00CFh		; 32bit data
		dw		0FFFFh, 0,  9A00h,  00CFh		; 32bit code
		
; ----------------------------------------------------------------------
; Protected mode
; ----------------------------------------------------------------------

		use32

pm:		mov		ax, 08h
		mov		ds, ax
		mov		es, ax
		mov		ss, ax
		mov		fs, ax
		mov		gs, ax
		mov		esp, 8000h
		jmp		8000h

; ----------------------------------------------------------------------
; ESTIMATED FILL ZERO
; ----------------------------------------------------------------------
		
		times	7c00h + (512 - 2) - $ db 0x00
		dw		0xAA55
		
		
