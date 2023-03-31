PUBLIC mat, mrows, mcols

EXTRN input_dims: NEAR
EXTRN input_matrix: NEAR
EXTRN delete_matching_columns: NEAR
EXTRN print_matrix: NEAR

STK SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    mat DB 51h DUP (?)
    mcols DB 0
    mrows DB 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CSEG, DS: DSEG, SS:STK

main:
    MOV AX, DSEG
    MOV DS, AX

    CALL input_dims
    CALL input_matrix
    CALL delete_matching_columns
    CALL print_matrix

main_end:
    MOV AH, 4Ch
    INT 21h

CSEG ENDS
END main
