PUBLIC mat, mwidth, mheight

STK SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
STK ENDS

DATASEG SEGMENT PARA PUBLIC 'DATA'
    mat DB 51h DUP (0) 
    mwidth DB 0
    mheight DB 0

    input_width_prompt DB "Input width: ", '$'
    input_height_prompt DB "Input height: ", '$'
    newline DB 13, 10, '$'
DATASEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS: DATASEG, SS:STK

print_newline:
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h
    ret

main:
    MOV AX, DATASEG
    MOV DS, AX

    MOV DX, OFFSET input_width_prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h

    MOV mwidth, AL

    CALL print_newline

    MOV DX, OFFSET input_height_prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h

    MOV mheight, AL

    CALL print_newline

    MOV AH, 02h

    MOV DL, mwidth
    INT 21h

    MOV DL, mheight
    INT 21h

    MOV AH, 4Ch
    INT 21h

CSEG ENDS
END main