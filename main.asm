print_string_in_pos MACRO row, col, string
    MOV AH, 02H
    MOV BH, 0
    MOV DH, row
    MOV DL, col
    INT 10H
    LEA DX, string
    MOV AH, 09H
    INT 21H
    ENDM

positionate_cursor MACRO row,col
    MOV AH, 02H
    MOV BH, 0
    MOV DH, row
    MOV DL, col
    INT 10H
    ENDM

print_char_in_pos MACRO row, col, char
    MOV AH, 02H
    MOV BH, 0
    MOV DH, row
    MOV DL, col
    INT 10H
    MOV AH, 02H
    MOV DL, char
    INT 21H
    ENDM

read_char MACRO
    MOV AH, 01H
    INT 21H
    ENDM

cln_screen MACRO
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    ENDM

.MODEL SMALL
.STACK 100H

.DATA
    ;Variables para la presentacion;
    Integrante_Uno DB "Gadiel Alejandro Fraire Ramírez - 22130542", '$'
    Integrante_Dos DB "Gerardo Enrique Ramos Espinoza - 21130599", '$'
    Presentan DB "Presentan: ", '$'
    Nombre_Programa DB "MODOS DE VIDEO Y GRÁFICOS", '$'
    Prompt_Presentacion DB "Presione cualquier tecla para continuar...", '$'

    ;Variables para menu de opciones;
    Menu_Decoracion DB "==================================",  '$'
    Menu_Titulo DB  "MENU PRINCIPAL",  '$'
    Menu_Opcion1 DB  "1. COLOREA TU FLOR",  '$'
    Menu_Opcion2 DB  "2. CONTROLA TU PERSONAJE",  '$'
    Menu_Opcion3 DB  "3. ANIMACIÓN (<ESC> para salir)",  '$'
    Menu_Opcion4 DB  "4. SALIR",  '$'
    Seleccion_Opcion DB  "Seleccine una opcion: ", '$'

    opcion DB 0

.CODE
extrn Programa_Flor:PROC
extrn Programa_Control:PROC
extrn Programa_Burbuja:PROC
inicio:
    MOV AX, @DATA
    MOV DS, AX

    cln_screen
    print_string_in_pos 1, 25, Menu_Decoracion
    print_string_in_pos 3, 23, Integrante_Uno 
    print_string_in_pos 4, 25, Integrante_Dos 
    print_string_in_pos 6, 35, Presentan
    print_string_in_pos 7, 30, Nombre_Programa 
    print_string_in_pos 9, 25, Menu_Decoracion
    print_string_in_pos 10, 23, Prompt_Presentacion 

    read_char

menu_opciones:
    cln_screen

    print_string_in_pos 1, 25, Menu_Decoracion
    print_string_in_pos 2, 35, Menu_Titulo
    print_string_in_pos 4, 30, Menu_Opcion1
    print_string_in_pos 5, 30, Menu_Opcion2
    print_string_in_pos 6, 30, Menu_Opcion3
    print_string_in_pos 7, 30, Menu_Opcion4
    print_string_in_pos 8, 25, Menu_Decoracion
    print_string_in_pos 9, 25, Seleccion_Opcion
    
    
    call validate_option

    jmp menu_opciones


    MOV AH, 4CH
    INT 21H

validate_option PROC NEAR
    print_char_in_pos 8,47,' '
    positionate_cursor 8,47
    read_char
    MOV opcion, AL
    CMP opcion, '1'
    JE opcion1
    CMP opcion, '2'
    JE opcion2
    CMP opcion, '3'
    JE opcion3
    CMP opcion, '4'
    JE opcion4
    JMP validate_option
opcion1:
    call Programa_Flor
    jmp menu_opciones
    
    
opcion2:
    call Programa_Control
    jmp menu_opciones
    
    
opcion3:
    call Programa_Burbuja
    jmp menu_opciones

opcion4:
    cln_screen
    MOV AH, 4CH
    INT 21H

    RET
validate_option ENDP

END inicio