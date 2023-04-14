public print_number_oct
extrn number: word

STK segment para stack 'STACK'
    db 200h dup (?)
STK ends

DSEG segment para public 'DATA'
    output_oct_prompt db "Octal signed number: ", '$'
DSEG ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ss:STK, ds:DSEG

print_number_oct proc near
    mov ah, 09h
    mov dx, offset output_oct_prompt
    int 21h

    mov cx, 5
    mov bx, number

    test bx, bx
    js number_neg
    jns start_print

number_neg:
    not bx ; перевод в доп код
    inc bx
    or bx, 08000h

start_print:
    rol bx, 1
    mov ax, bx
    and ax, 1b
    mov dl, al
    mov ah, 02h
    add dl, 30h

    int 21h

print_digits_oct_loop:
    push cx
    mov cl, 3
    rol bx, cl
    mov ax, bx
    and ax, 111b
    pop cx

    mov dl, al
    mov ah, 02h
    add dl, 30h

    int 21h
    loop print_digits_oct_loop

    ret
print_number_oct endp

CSEG ends
end