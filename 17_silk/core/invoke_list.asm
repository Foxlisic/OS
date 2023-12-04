; **********************************************************************
; Здесь размещены все необходимые ссылки на Kernel Invokes
; Этим листингом могут пользоваться все, у кого есть привилегии доступа
; 
; Суть списка в том, что системные могут быть переназначены внешним
; подключаемым драйвером. Это зависит от привилегии самого драйвера.
; **********************************************************************

; Функции ядра
ikernel:

    ; Управление памятью. Создать блок в системной памяти (ring-0)
    .kmalloc                dd 0
    .kfree                  dd 0
    .krealloc               dd 0

; RAM-диск
iramdisk:

    .create_file            dd 0
    .delete_file            dd 0

; Вывод на терминал
iterm:

    .print_sz               dd 0    ; Печать строки
    .putc                   dd 0    ; Печать буквы   

; ----------------------------------------------------------------------
; @TODO Секция для поиска функции для внешних модулей

dd ikernel.kmalloc
db "kernel/malloc", 0