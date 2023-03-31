PUBLIC input_matrix
PUBLIC print_matrix
PUBLIC input_dims

EXTRN mat: BYTE
EXTRN mrows: BYTE
EXTRN mcols: BYTE

DSEG SEGMENT PARA PUBLIC 'DATA'
    input_rows_prompt DB "Input rows amount (1-9): ", '$'
    input_cols_prompt DB "Input cols amount (1-9): ", '$'
    empty_matrix_msg  DB "Empty matrix", '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG

print_newline PROC
    MOV AH, 02h
    MOV DL, 13
    INT 21h

    MOV DL, 10
    INT 21h
    RET
print_newline ENDP

input_dims PROC NEAR
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
    RET
input_dims ENDP

input_matrix PROC NEAR
    XOR BX, BX
    XOR CH, CH
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
    ADD BX, 09h
    POP CX
    LOOP input_loop1
    CALL print_newline
    RET
input_matrix ENDP

print_matrix PROC NEAR
    XOR BX, BX
    XOR CH, CH
    MOV CL, mrows

print_loop1:
    PUSH CX
    MOV CL, mcols
    CMP CL, 0h
    JE print_empty_matrix
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
    ADD BX, 09h
    POP CX
    LOOP print_loop1
    JMP print_matrix_end

print_empty_matrix:
    POP CX
    MOV AH, 09h
    MOV DX, OFFSET empty_matrix_msg
    INT 21h

print_matrix_end:
    RET

print_matrix ENDP
CSEG ENDS
END