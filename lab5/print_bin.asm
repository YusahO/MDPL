public print_number_bin
extrn number: word

CSEG segment para public 'CODE'
    assume cs:CSEG

print_number_bin proc near
    mov cx, 16
    mov bx, number
    mov ah, 02h

print_digits_bin_loop:
    mov dl, 30h
    rol bx, 1
    jnc print_zero_bin
    inc dl

print_zero_bin:
    int 21h
    loop print_digits_bin_loop

print_number_bin endp

CSEG ends
end
