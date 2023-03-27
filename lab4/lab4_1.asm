PUBLIC mat, mcols, mrows

STK SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    mat DB 51h DUP (?) 
    matches DB 0
    mcols DB 0
    mrows DB 0

    maxrows DW 09h
    maxcols DW 09h

    input_rows_prompt DB "Input rows amount (1-9): ", '$'
    input_cols_prompt DB "Input cols amount (1-9): ", '$'
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
    ADD BX, maxcols
    POP CX
    LOOP input_loop1
    RET
input_matrix ENDP

print_matrix PROC
    XOR BX, BX
    XOR CH, CH
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
    ADD BX, maxcols
    POP CX
    LOOP print_loop1
    RET
print_matrix ENDP

delete_column PROC
    DEC BX
    MOV CL, mrows
    XOR DI, DI
delete_column_loop1:
    PUSH CX
    MOV CL, mcols
    SUB CL, BL
    DEC CL
    ; MOV SI, BX
    MOV SI, DI
    CMP CL, 0h
    JE delete_column_end
    delete_column_loop2:
        MOV AL, mat[SI][bx+1]
        MOV mat[SI][bx], AL
        INC SI
        LOOP delete_column_loop2
    MOV mat[si][bx], 0
    POP CX
    ADD DI, maxcols
    ; MOV SI, DI
    LOOP delete_column_loop1
delete_column_end:
    MOV AL, mcols ; уменьшение количества столбцов на 1
    DEC AL
    MOV mcols, AL
    RET
delete_column ENDP

delete_matching_columns PROC
    XOR BX, BX
    XOR SI, SI
    XOR CH, CH
    MOV CL, mcols
find_columns_loop1:
    PUSH CX
    MOV CL, mrows

    find_columns_loop2:
        CMP mat[BX][SI], 'A'
        JNE finish_loop2
        ADD SI, maxrows
        LOOP find_columns_loop2

    finish_loop2:
        INC BX

        CMP CL, 0h
        JE need_to_delete_col
        JNE continue_loop2

    need_to_delete_col:
        CALL delete_column

    continue_loop2:
        XOR SI, SI
        POP CX
        LOOP find_columns_loop1
    RET
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
    CALL delete_matching_columns
    CALL print_matrix

    MOV AH, 4Ch
    INT 21h

CSEG ENDS
END main
