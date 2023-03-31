STK segment para stack 'STACK'
    db 200h dup (?)
STK ends

DSEG segment para public 'DATA'
    number dw 0
    input_num_msg db "Input number: ", '$'
DSEG ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ss:STK, ds:DSEG

input_number proc
    mov ah, 09h
    mov dx, offset input_num_msg
    int 21h

    mov cx, 4h

read_digits:
    mov ax, number
    mov bl, 16
    mul bl
    mov number, ax

    mov ah, 01h
    int 21h

    cmp al, 0dh      ; конец ввода 
    je after_reading

    cmp al, '9'
    jle digits_dec
    jg digits_hex

digits_dec:
    sub al, '0'
    jmp write_to_num

digits_hex:
    sub al, 55

write_to_num:
    xor dh, dh
    mov dl, al
    mov ax, number
    add ax, dx
    mov number, ax

    loop read_digits

after_reading:
    ret
input_number endp

print_number_hex proc
    mov cx, 4h
print_digits_hex:
    xor dx, dx
    mov ax, number
    div 
    mov number, ax

print_number_hex endp

print_newline:
    mov ah, 02h

    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ret

main:
    mov ax, DSEG
    mov ds, ax

    call input_number

    mov ah, 4ch
    int 21h

CSEG ends
end main