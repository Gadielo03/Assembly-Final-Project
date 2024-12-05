.MODEL SMALL
.STACK 100H

.DATA
    MSG DB 'Hello, World!', '$'

.CODE 
    MOV AX, @DATA
    MOV DS, AX

    

END