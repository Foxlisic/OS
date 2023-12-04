; --------------------------------------------------------
; Создание дескриптора в реальном режиме
; EAX - Лимит 24
; EBX - Адрес 32
; CX  - Конфигурация
; ES:DI - Указатель на элемент GDT
; --------------------------------------------------------

create_descriptor:

    stosw ; limit
    
    xchg  eax, ebx
    stosw ; address 0..15
    
    shr   eax, 16
    stosb ; addr 16..23

    xchg  eax, ebx
    mov   al, cl
    stosb ; config low

    shr   eax, 16
    or    al, ch
    stosb ; config + limit

    xchg  eax, ebx
    shr   ax, 8
    stosb ; addr 24..31

    ret

; Создание первичной таблицы GDT
create_initial_gdt:

    mov ax, 0x0400
    mov es, ax

    ; Очистить GDT (1024 элементов)
    xor di, di
    mov cx, 0x2000
    xor ax, ax
    rep stosb

    mov di, 8    
    
    ; ---

    ; CS: ~600 kb кода, который может быть загружен
    mov eax, 0x93FFF 
    xor ebx, ebx                 ; База в 0x00000000
    mov cx,  0x90 + 0x8 + 0x4000 ; DPL=0, PRESENT=0x80, BIT_SYSTEM=0x10, CODE_EXEC_ONLY=0x8, BIT_DEFAULT_SIZE_32=0x4000
    call create_descriptor

    ; DS: SS: ES Вся память в целом на чтение и запись
    mov eax, 0xFFFFF
    xor ebx, ebx
    mov cx,  0x90 + 0x2 + 0x4000 + 0x8000 ; DATA_READ_WRITE=0x2
    call create_descriptor
    
    ; ---

    ; Загрузка GDT
    mov word  [0x7C00], 0x1FFF 
    mov dword [0x7C02], 0x4000
    lgdt [0x7C00]

    ; Загрузка IDT
    mov word  [0x7C06], 0x7FF
    mov dword [0x7C08], 0x6000
    lidt [0x7C06]
    ret    
