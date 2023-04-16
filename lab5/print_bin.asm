public print_number_bin
extrn number: word

DSEG segment para public 'DATA'
    output_bin_prompt db "Binary unsigned number: ", '$'
DSEG ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ds:DSEG

print_number_bin proc near
    mov ah, 09h
    mov dx, offset output_bin_prompt
    int 21h

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

    ret
print_number_bin endp

CSEG ends
end
