public number
public print_newline
extrn input_number: near, print_number_bin: near, print_number_oct: near

DSEG segment para public 'DATA'
    number dw 0
    menu db 13, 10, 10, "1. Input unsigned hex number", 13, 10
         db "2. Print unsigned in binary", 13, 10
         db "3. Print signed in octal", 13, 10
         db "4. Exit", 13, 10, 10
         db "Input action: ", '$'
    
    error_action_prompt db 13, 10, "Error: invalid action", 13, 10, '$'
    actions dw input_number, print_number_bin, print_number_oct, exit_program
DSEG ends

CSEG segment para public 'CODE'
    assume cs:CSEG, ds:DSEG

print_newline proc near
    mov ah, 02h

    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ret
print_newline endp

exit_program proc near
    mov ah, 4ch
    int 21h
exit_program endp

main:
    mov ax, DSEG
    mov ds, ax

interact_with_menu:
    mov ah, 09h
    mov dx, offset menu
    int 21h

    mov ah, 01h
    int 21h

    cmp al, 31h
    jl error_action
    cmp al, 34h
    jg error_action

    xor ah, ah
    sub al, 31h

    mov cl, 2
    mul cl

    mov si, ax

    call print_newline
    call actions[si]
    jmp loop_end

error_action:
    mov dx, offset error_action_prompt
    mov ah, 09h
    int 21h

loop_end:
    jmp interact_with_menu

CSEG ends
end main
