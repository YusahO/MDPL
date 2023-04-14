public input_number
extrn number: word

STK segment para stack 'STACK'
    db 50h dup (?)
STK ends

DSEG segment para public 'DATA'
    input_num_msg db "Input number: ", '$'
DSEG ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ss:STK
    
input_number proc near
    mov ah, 09h
    mov dx, offset input_num_msg
    int 21h
    mov number, 0

    mov cx, 4h
    xor dx, dx
read_digits:
    mov ah, 01h
    int 21h
    cmp al, 0dh      ; конец ввода 
    je after_reading

    push ax
    mov ax, number
    mov bx, 16
    mul bx
    mov number, ax
    pop ax

    cmp al, '9'
    jle read_case_dec
    jg read_case_hex

read_case_dec:
    sub al, '0'
    jmp write_to_num

read_case_hex:
    sub al, 55

write_to_num:
    mov dl, al
    mov ax, number
    add ax, dx
    mov number, ax

    loop read_digits

after_reading:
    ret
input_number endp
CSEG ends
end
