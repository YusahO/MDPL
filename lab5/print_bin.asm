public print_number_bin
extrn number: word

STK segment para stack 'STACK'
    db 200h dup (?)
STK ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ss:STK

print_number_bin proc near
    mov cx, 16
    mov ax, number

digits_bin_store_in_stack:
    xor dx, dx
    mov bx, 2
    div bx
    
    add dl, '0'
    push dx

    cmp ax, 0
    je print_digits_bin
    loop digits_bin_store_in_stack

print_digits_bin:
    mov ah, 02h
    mov ch, 16
    sub ch, cl
    mov cl, ch
    inc cl
    xor ch, ch
    
print_digits_bin_loop:
    pop dx
    int 21h
    loop print_digits_bin_loop

    ret
print_number_bin endp

CSEG ends
end
