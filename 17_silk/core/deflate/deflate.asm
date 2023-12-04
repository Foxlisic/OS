; **********************************************************************
; Этот модуль производит распаковку данных, упакованным методом 
; deflate. Это нужно для того, чтобы распаковать данные, которые были
; упакованы в конце файла sys.bin, в RAM-диск
; **********************************************************************

; Здесь записывается указатель на базу для распаковки потока
deflate_stream_base     dd 0 ; Откуда 
deflate_bit             db 0 ; 0..7
deflate_destination     dd 0 ; Куда распаковывать
deflate_index           dw 0 ; Индекс указателя в словаре 

; Получение следующего бита из потока
deflate_get_bit:

    ret

; РАСПАКОВАТЬ 
; Исходные данные в esi
; Данные для распаковки в edi
; ----------------------------------------------------------------------

deflate_unpack:

    ; Инициализация потока
    mov     [deflate_stream_base], esi
    mov     [deflate_destination], edi
    mov     [deflate_bit], byte 0
    mov     [deflate_index], word 0
    ret

