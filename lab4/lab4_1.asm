PUBLIC mat, mcols, mrows

STK SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    mat DB 51h DUP (?) 
    matches DB 0
    mcols DB 0
    mrows DB 0

    input_rows_prompt DB "Input rows amount (1-9): ", '$'
    input_cols_prompt DB "Input cols amount (1-9): ", '$'
    input_elem_prompt DB "Input element: ", '$'
    cur_row_prompt DB "Row ", '$'
    newline DB 13, 10, '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS: DSEG, SS:STK

print_newline:
    MOV DX, OFFSET newline
    MOV AH, 09h
    INT 21h
    RET

input_matrix PROC
    XOR BX, BX
    XOR CX, CX
    MOV CL, mrows
input_loop1:
    PUSH CX
    MOV CL, mcols
    XOR SI, SI
    input_loop2:
        MOV AH, 01h
        INT 21h

        MOV mat[BX][SI], AL

        MOV DL, ' '
        MOV AH, 02h
        INT 21h

        INC SI
        LOOP input_loop2

    CALL print_newline
    ADD BL, mcols
    POP CX
    LOOP input_loop1

    RET
input_matrix ENDP

print_matrix PROC
    XOR BX, BX
    XOR CX, CX
    MOV CL, mrows
print_loop1:
    PUSH CX
    MOV CL, mcols
    MOV AH, 02h
    XOR SI, SI
    print_loop2:
        MOV DL, mat[BX][SI]
        INT 21h
        
        MOV DL, ' '
        INT 21h
        INC SI
        LOOP print_loop2

    CALL print_newline 
    ADD BL, mcols
    POP CX
    LOOP print_loop1

    RET
print_matrix ENDP

delete_matching_columns PROC

delete_matching_columns ENDP

main:
    MOV AX, DSEG
    MOV DS, AX

    MOV DX, OFFSET input_rows_prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h

    SUB AL, 30h
    MOV mrows, AL

    CALL print_newline

    MOV DX, OFFSET input_cols_prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h

    SUB AL, 30h
    MOV mcols, AL

    CALL print_newline

    CALL input_matrix
    CALL print_newline
    CALL print_matrix

    MOV AH, 4Ch
    INT 21h

CSEG ENDS
END main
