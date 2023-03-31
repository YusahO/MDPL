PUBLIC delete_matching_columns

EXTRN mat: BYTE
EXTRN mrows: BYTE
EXTRN mcols: BYTE

DSEG SEGMENT PARA PUBLIC 'DATA'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG

delete_column PROC
    DEC BX
    MOV CL, mrows
    XOR DI, DI

delete_column_loop1:
    PUSH CX
    ; вычисление количества элементов, которые нужно сместить
    MOV CL, mcols
    SUB CL, BL
    DEC CL

    MOV SI, DI
    CMP CL, 0h
    JE no_shift

    delete_column_loop2:
        MOV AL, mat[SI][BX + 1]
        MOV mat[SI][BX], AL
        INC SI
        LOOP delete_column_loop2

    MOV mat[SI][BX], 0
    POP CX
    ADD DI, 09h
    LOOP delete_column_loop1
    JMP delete_column_end

no_shift:
    POP CX

delete_column_end:
    MOV AL, mcols ; уменьшение количества столбцов на 1
    DEC AL
    MOV mcols, AL
    RET
delete_column ENDP

delete_matching_columns PROC NEAR
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
        ADD SI, 09h
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
CSEG ENDS
END