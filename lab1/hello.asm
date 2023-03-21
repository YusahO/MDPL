.MODEL TINY
.DOSSEG
.DATA
    MSG DB "Hello, World!", 0Dh, 0Ah
    SUR DB "SHUBENINA", 0Dh, 0Ah, '$'
.CODE
.STARTUP
    MOV AH, 09h
    MOV DX, OFFSET MSG
    INT 21h
    mov DX, OFFSET SUR
    INT 21h
    MOV AH, 4Ch
    INT 21h
END