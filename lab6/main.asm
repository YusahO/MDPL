.model tiny
.186

CSEG segment para public 'CODE'
    assume cs:CSEG, ds:CSEG
    org 100h

main:
    jmp INIT

    delay db 11111b
    oldint dd ?
    intercepted db 1
    current_time db 0

MYINT:
    pusha

my_interrupt_call_old:
    pushf
    call cs:oldint

    mov ah, 02h
    int 1ah ; получение доступа к системным часам. DH -- время в секундах

    cmp dh, current_time
    je my_interrupt_end
    mov current_time, dh

    mov al, 0f3h

    out 60h, al
    mov al, delay
    out 60h, al

    dec delay
    test delay, 11111b
    jz my_interrupt_reset_delay
    jmp my_interrupt_end

my_interrupt_reset_delay:
    mov delay, 11111b

my_interrupt_end:
    popa
    iret

INIT:
    mov ax, 3508h
    int 21h  ; получить адрес прерывания ввода без эха

    cmp es:intercepted, 1
    je UNINSTALL

    jmp INSTALL

INSTALL:
    mov word ptr oldint, bx
    mov word ptr oldint + 2, es

    mov ax, 2508h ; установить свой обработчик

    mov dx, offset MYINT
    int 21h

    mov dx, offset INIT
    int 27h

UNINSTALL:
    pusha
    mov dx, word ptr es:oldint
    mov ds, word ptr es:oldint + 2

    mov ax, 2508h
    int 21h

    mov al, 0f3h
    out 60h, al
    mov al, 0
    out 60h, al

    popa

    mov ah, 49h ; освобождение блока памяти, начинающегося с адреса ES:0000
    int 21h

    mov ah, 4Ch
    int 21h

CSEG ends
end main
