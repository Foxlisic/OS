macro   brk     { xchg bx, bx }
        org     7c00h
; ----------------------------------------------------------------------

        cli                 ; IF=0
        cld                 ; DF=0
        xor     ax, ax      ; Установка всех сегментов в 0
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     sp, 7C00h

        ; Выдача HELLO WORLD
        mov     ax, 0003h
        int     10h         ; 640x400 текстовый (80x25; 8x16)

        mov     si, cHelloWorld
@@:     lodsb
        and     al, al
        je      $           ; Остановка процессора
        mov     ah, 0Eh
        int     10h         ; BIOS-прерывание с функцией AH=0Eh печать символа
        jmp     @b

; ----------------------------------------------------------------------
cHelloWorld:

        db      "Hello World!",0
