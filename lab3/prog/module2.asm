PUBLIC receive_values
EXTRN VAL1: BYTE
EXTRN VAL2: BYTE

DS2 SEGMENT PARA 'DATA'
    NEWLINE DB 13
            DB 10
            DB '$'
    INPUTPROMPT1 DB 'Input 1st value: ', '$'
    INPUTPROMPT2 DB 'Input 2nd value: ', '$'
DS2 ENDS

CS2 SEGMENT PARA 'CODE'
    ASSUME DS: DS2, CS: CS2

print_newline:
    MOV DX, OFFSET NEWLINE
    MOV AH, 09h
    INT 21h
    RET

receive_values PROC FAR
    MOV AX, DS2
    MOV DS, AX

    MOV DX, OFFSET INPUTPROMPT1
    MOV AH, 09h
    INT 21h

    MOV AX, SEG VAL1
    MOV ES, AX

    MOV AH, 01h
    INT 21h

    MOV ES:VAL1, AL

    CALL print_newline

    MOV DX, OFFSET INPUTPROMPT2
    MOV AH, 09h
    INT 21h

    MOV AX, SEG VAL2
    MOV ES, AX

    MOV AH, 01h
    INT 21h

    MOV ES:VAL2, AL

    CALL print_newline

    RET
receive_values endp
CS2 ENDS
END