; ----------------------------------------------------------------------
; SILK Operation System for Education Purposes
; ----------------------------------------------------------------------
;
; Это заготовка для входа в защищенный режим, его конфигурирования
;
; **********************************************************************
; COMPILE AS: sh make.sh
; RUNNING AT: [0000:0800]
; **********************************************************************

    org     0x0800

    cli
    include "macros.asm"
    include "constants.asm"
    ; -- realmode --
    include "pm32/enter.asm"
    use32

; **********************************************************************
__start_protected_mode:

    ; Загрузка ссылки на главную задачу ядра (0-й RING)
    mov     ax,  DESCRIPTOR_MAIN_TSS
    ltr     ax

    ; Загрузка сегментов для защищенного режима
    mov     ax,  DESCRIPTOR_DATA_RING0
    mov     es,  ax
    mov     ds,  ax
    mov     ss,  ax
    mov     esp, 0x101000 ; 4096 байта на стек

    ; Установка системного таймера на 100 Гц
    mov     al, 0x34
    out     0x43, al
    mov     ax, 0x2E9B
    out     0x40, al ; lsb
    mov     al, ah
    out     0x40, al ; msb

    ; Выполнение IRQ-редиректов для новой таблицы IDT
    include "pm32/irq_redirect_pic.asm"

    ; Определить максимальный размер физической памяти
    include "pm32/memsize.asm"

    ; Инициализация таблицы прерываний и обработчиков
    include "pm32/interrupts.asm"

    ; Включение страничного механизма
    include "pm32/paging.asm"

; ----------------------------------------------------------------------
; ДАЛЕЕ ИДЕТ ПОЛЬЗОВАТЕЛЬСКИЙ КОД 