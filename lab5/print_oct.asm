public print_number_oct
extrn number: word

STK segment para stack 'STACK'
    db 200h dup (?)
STK ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ss:STK

print_number_oct proc near
    mov cx, 8
    mov ax, number

    test ax, ax
    js number_neg
    jns digits_oct_store_in_stack

number_neg:
    mov bx, 0FFFFh ; преобразование в доп код
    xor ax, bx
    inc ax

    push ax        ; вывод знака '-'
    mov ah, 02h
    mov dl, '-'
    int 21h
    pop ax

digits_oct_store_in_stack:
    xor dx, dx
    mov bx, 8
    div bx
    
    add dl, '0'
    push dx

    cmp ax, 0
    je print_digits_oct
    loop digits_oct_store_in_stack

print_digits_oct:
    mov ah, 02h
    mov ch, 8
    sub ch, cl
    mov cl, ch
    inc cl
    xor ch, ch

print_digits_oct_loop:
    pop dx
    int 21h
    loop print_digits_oct_loop

    ret
print_number_oct endp

CSEG ends
end
