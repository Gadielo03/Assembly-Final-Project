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

cln_screen MACRO
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    ENDM

read_char MACRO
    MOV AH, 01H
    INT 21H
    ENDM

print_menu MACRO row,col,menu_op
    cln_screen
    print_string_in_pos row,col,menu_op
    call show_color_menu
    ENDM

set_video_mode MACRO mode 
	mov al, mode
	mov ah, 0
	int 10h
    ENDM

print_char_in_pos_color MACRO row, col, char, color
    positionate_cursor row, col
    MOV ah, 09h
    MOV al, char
    MOV bl, color
    MOV cx, 1
    INT 10h
    ENDM

reset_video_attributes MACRO
    MOV AX, 0600h
    MOV BH, 07h    ; 07h = Light gray on black
    MOV CX, 0000h  ; Upper left corner
    MOV DX, 184Fh  ; Lower right corner
    INT 10h
    
    cln_screen
    positionate_cursor 0, 0
    ENDM

.MODEL SMALL
.STACK 100H

.DATA
    Menu_Tittle DB "Personaliza tu Flor", '$'
    Menu_Decoracion DB "==================================", '$'
    Menu_Opcion1 DB "1. Cambiar color de los petalos", '$'
    Menu_Opcion2 DB "2. Cambiar color del centro", '$'
    Menu_Opcion3 DB "3. Cambiar color del tallo", '$'
    Menu_Opcion4 DB "4. Cambiar color del fondo", '$'  
    Menu_Instrucciones1 DB "Presiona cualquier boton para salir ", '$'
    Menu_Instrucciones2 DB "despues de ver la imagen para salir", '$'
    
    Seleccion_Opcion DB "Selecciona una opcion: ", '$'  
    color_negro DB "0-Negro", '$'
    color_azul DB "1-Azul", '$'
    color_verde DB "2-Verde", '$'
    color_cyan DB "3-Cian", '$'
    color_rojo DB "4-Rojo", '$'
    color_magenta DB "5-Magenta", '$'
    color_marron DB "6-Marron", '$'
    color_gris_claro DB "7-Gris claro", '$'
    color_gris_oscuro DB "8-Gris oscuro", '$'

    color_petalos DB ?
    color_centro DB ?
    color_tallo DB ?
    color_fondo DB ?

    col DB 0
    row DB 0

.CODE 
inicio:
    MOV AX, @DATA
    MOV DS, AX
    
    set_video_mode 03h
    cln_screen

    

    print_menu 4,25,Menu_Opcion1
    call validate_color
    MOV color_petalos, AL

    print_menu 4,25,Menu_Opcion2
    call validate_color
    MOV color_centro, AL

    print_menu 4,25,Menu_Opcion3
    call validate_color
    MOV color_tallo, AL

    print_menu 4,25,Menu_Opcion4
    call validate_color
    MOV color_fondo,AL

    cln_screen

    call paint_background

    call paint_screen
    
    MOV AH, 00h
    INT 16h  

    cln_screen

    reset_video_attributes
    

    jmp end_program

show_color_menu PROC NEAR
    print_string_in_pos 2, 25, Menu_Decoracion
    print_string_in_pos 3, 25, Menu_Tittle
    print_string_in_pos 5, 25  Menu_Decoracion
    print_string_in_pos 6, 25, Menu_Instrucciones1
    print_string_in_pos 7, 25, Menu_Instrucciones2
    print_string_in_pos 8, 25, Menu_Decoracion
    print_string_in_pos 9, 25, color_negro
    print_string_in_pos 10, 25, color_azul
    print_string_in_pos 11, 25, color_verde
    print_string_in_pos 12, 25, color_cyan
    print_string_in_pos 13, 25, color_rojo
    print_string_in_pos 14, 25, color_magenta
    print_string_in_pos 15, 25, color_marron
    print_string_in_pos 16, 25, color_gris_claro
    print_string_in_pos 17, 25, color_gris_oscuro
    print_string_in_pos 18, 25, Seleccion_Opcion
    RET
show_color_menu ENDP

validate_color PROC NEAR
color_validator_start:
    print_char_in_pos 18,47,' '
    positionate_cursor 18,47
    read_char
    SUB AL,'0'
    CMP AL, 0
    JL color_validator_start
    CMP AL, 8
    JG color_validator_start
    RET
validate_color ENDP

paint_screen PROC NEAR
    print_char_in_pos_color 6,19,219,color_petalos
    print_char_in_pos_color 6,20,219,color_petalos
    print_char_in_pos_color 6,21,219,color_petalos
    print_char_in_pos_color 6,22,219,color_petalos
    print_char_in_pos_color 6,23,219,color_petalos
    print_char_in_pos_color 6,24,219,color_petalos

    print_char_in_pos_color 7,17,219,color_petalos
    print_char_in_pos_color 7,18,219,color_petalos
    print_char_in_pos_color 7,19,219,color_petalos
    print_char_in_pos_color 7,20,219,color_petalos
    print_char_in_pos_color 7,21,219,color_petalos
    print_char_in_pos_color 7,22,219,color_petalos
    print_char_in_pos_color 7,23,219,color_petalos
    print_char_in_pos_color 7,24,219,color_petalos

    print_char_in_pos_color 8,16,219,color_petalos
    print_char_in_pos_color 8,17,219,color_petalos
    print_char_in_pos_color 8,18,219,color_petalos
    print_char_in_pos_color 8,19,219,color_petalos
    print_char_in_pos_color 8,20,219,color_petalos
    print_char_in_pos_color 8,21,219,color_petalos
    print_char_in_pos_color 8,22,219,color_petalos
    print_char_in_pos_color 8,23,219,color_petalos
    print_char_in_pos_color 8,24,219,color_petalos
    print_char_in_pos_color 8,25,219,color_petalos
    print_char_in_pos_color 8,26,219,color_petalos

    print_char_in_pos_color 9,15,219,color_petalos
    print_char_in_pos_color 9,16,219,color_petalos
    print_char_in_pos_color 9,17,219,color_petalos
    print_char_in_pos_color 9,18,219,color_petalos
    print_char_in_pos_color 9,19,219,color_petalos
    print_char_in_pos_color 9,20,219,color_petalos
    print_char_in_pos_color 9,21,219,color_petalos
    print_char_in_pos_color 9,22,219,color_petalos
    print_char_in_pos_color 9,23,219,color_petalos
    print_char_in_pos_color 9,24,219,color_petalos
    print_char_in_pos_color 9,25,219,color_petalos
    print_char_in_pos_color 9,26,219,color_petalos
    print_char_in_pos_color 9,27,219,color_petalos
    print_char_in_pos_color 9,28,219,color_petalos

    print_char_in_pos_color 10,14,219,color_petalos
    print_char_in_pos_color 10,15,219,color_petalos
    print_char_in_pos_color 10,16,219,color_petalos
    print_char_in_pos_color 10,17,219,color_petalos
    print_char_in_pos_color 10,18,219,color_petalos
    print_char_in_pos_color 10,19,219,color_petalos
    print_char_in_pos_color 10,20,219,color_petalos
    print_char_in_pos_color 10,21,219,color_centro
    print_char_in_pos_color 10,22,219,color_centro
    print_char_in_pos_color 10,23,219,color_centro
    print_char_in_pos_color 10,24,219,color_petalos
    print_char_in_pos_color 10,25,219,color_petalos
    print_char_in_pos_color 10,26,219,color_petalos
    print_char_in_pos_color 10,27,219,color_petalos
    print_char_in_pos_color 10,28,219,color_petalos
    print_char_in_pos_color 10,29,219,color_petalos

    print_char_in_pos_color 11,15,219,color_petalos
    print_char_in_pos_color 11,16,219,color_petalos
    print_char_in_pos_color 11,17,219,color_petalos
    print_char_in_pos_color 11,18,219,color_petalos
    print_char_in_pos_color 11,19,219,color_petalos
    print_char_in_pos_color 11,20,219,color_centro
    print_char_in_pos_color 11,21,219,color_centro
    print_char_in_pos_color 11,22,219,color_centro
    print_char_in_pos_color 11,23,219,color_centro
    print_char_in_pos_color 11,24,219,color_centro
    print_char_in_pos_color 11,25,219,color_petalos
    print_char_in_pos_color 11,26,219,color_petalos
    print_char_in_pos_color 11,27,219,color_petalos
    print_char_in_pos_color 11,28,219,color_petalos
    print_char_in_pos_color 11,29,219,color_petalos
    print_char_in_pos_color 11,30,219,color_petalos
    print_char_in_pos_color 11,31,219,color_petalos

    print_char_in_pos_color 12,14,219,color_petalos
    print_char_in_pos_color 12,15,219,color_petalos
    print_char_in_pos_color 12,16,219,color_petalos
    print_char_in_pos_color 12,17,219,color_petalos
    print_char_in_pos_color 12,18,219,color_petalos
    print_char_in_pos_color 12,19,219,color_petalos
    print_char_in_pos_color 12,20,219,color_centro
    print_char_in_pos_color 12,21,219,color_centro
    print_char_in_pos_color 12,22,219,color_centro
    print_char_in_pos_color 12,23,219,color_centro
    print_char_in_pos_color 12,24,219,color_centro
    print_char_in_pos_color 12,25,219,color_petalos
    print_char_in_pos_color 12,26,219,color_petalos
    print_char_in_pos_color 12,27,219,color_petalos
    print_char_in_pos_color 12,28,219,color_petalos
    print_char_in_pos_color 12,29,219,color_petalos
    print_char_in_pos_color 12,30,219,color_petalos
    print_char_in_pos_color 12,31,219,color_petalos
    print_char_in_pos_color 12,32,219,color_petalos

    print_char_in_pos_color 13,14,219,color_petalos
    print_char_in_pos_color 13,15,219,color_petalos
    print_char_in_pos_color 13,16,219,color_petalos
    print_char_in_pos_color 13,17,219,color_petalos
    print_char_in_pos_color 13,18,219,color_petalos
    print_char_in_pos_color 13,19,219,color_petalos
    print_char_in_pos_color 13,20,219,color_petalos
    print_char_in_pos_color 13,21,219,color_petalos
    print_char_in_pos_color 13,22,219,color_centro
    print_char_in_pos_color 13,23,219,color_centro
    print_char_in_pos_color 13,24,219,color_centro
    print_char_in_pos_color 13,25,219,color_petalos
    print_char_in_pos_color 13,26,219,color_petalos
    print_char_in_pos_color 13,27,219,color_petalos
    print_char_in_pos_color 13,28,219,color_petalos
    print_char_in_pos_color 13,29,219,color_petalos
    print_char_in_pos_color 13,30,219,color_petalos
    print_char_in_pos_color 13,31,219,color_petalos

    print_char_in_pos_color 14,14,219,color_petalos
    print_char_in_pos_color 14,15,219,color_petalos
    print_char_in_pos_color 14,16,219,color_petalos
    print_char_in_pos_color 14,17,219,color_petalos
    print_char_in_pos_color 14,18,219,color_petalos
    print_char_in_pos_color 14,19,219,color_petalos
    print_char_in_pos_color 14,20,219,color_petalos
    print_char_in_pos_color 14,21,219,color_petalos
    print_char_in_pos_color 14,22,219,color_petalos
    print_char_in_pos_color 14,23,219,color_petalos
    print_char_in_pos_color 14,24,219,color_petalos
    print_char_in_pos_color 14,25,219,color_petalos
    print_char_in_pos_color 14,26,219,color_petalos
    print_char_in_pos_color 14,27,219,color_petalos
    print_char_in_pos_color 14,28,219,color_petalos
    print_char_in_pos_color 14,29,219,color_petalos
    print_char_in_pos_color 14,30,219,color_petalos

    print_char_in_pos_color 15,14,219,color_petalos
    print_char_in_pos_color 15,15,219,color_petalos
    print_char_in_pos_color 15,16,219,color_petalos
    print_char_in_pos_color 15,17,219,color_petalos
    print_char_in_pos_color 15,18,219,color_petalos
    print_char_in_pos_color 15,19,219,color_petalos
    print_char_in_pos_color 15,20,219,color_petalos
    print_char_in_pos_color 15,21,219,color_petalos
    print_char_in_pos_color 15,22,219,color_petalos
    print_char_in_pos_color 15,23,219,color_petalos
    print_char_in_pos_color 15,24,219,color_petalos
    print_char_in_pos_color 15,25,219,color_petalos
    print_char_in_pos_color 15,26,219,color_petalos
    print_char_in_pos_color 15,27,219,color_petalos
    print_char_in_pos_color 15,28,219,color_petalos

    print_char_in_pos_color 16,15,219,color_petalos
    print_char_in_pos_color 16,16,219,color_petalos
    print_char_in_pos_color 16,17,219,color_petalos
    print_char_in_pos_color 16,18,219,color_petalos
    print_char_in_pos_color 16,19,219,color_petalos
    print_char_in_pos_color 16,20,219,color_petalos
    print_char_in_pos_color 16,21,219,color_petalos
    print_char_in_pos_color 16,22,219,color_petalos
    print_char_in_pos_color 16,23,219,color_tallo
    print_char_in_pos_color 16,24,219,color_tallo
    print_char_in_pos_color 16,25,219,color_tallo
    print_char_in_pos_color 16,26,219,color_petalos
    print_char_in_pos_color 16,27,219,color_petalos
    print_char_in_pos_color 16,28,219,color_petalos

    print_char_in_pos_color 17,19,219,color_petalos
    print_char_in_pos_color 17,20,219,color_petalos
    print_char_in_pos_color 17,21,219,color_petalos
    print_char_in_pos_color 17,22,219,color_petalos
    print_char_in_pos_color 17,23,219,color_tallo
    print_char_in_pos_color 17,24,219,color_tallo
    print_char_in_pos_color 17,25,219,color_tallo
    print_char_in_pos_color 17,26,219,color_tallo

    print_char_in_pos_color 18,20,219,color_petalos
    print_char_in_pos_color 18,21,219,color_petalos
    print_char_in_pos_color 18,22,219,color_petalos
    print_char_in_pos_color 18,23,219,color_tallo
    print_char_in_pos_color 18,24,219,color_tallo
    print_char_in_pos_color 18,25,219,color_tallo
    print_char_in_pos_color 18,26,219,color_tallo

    print_char_in_pos_color 19,23,219,color_tallo
    print_char_in_pos_color 19,24,219,color_tallo
    print_char_in_pos_color 19,25,219,color_tallo
    print_char_in_pos_color 19,26,219,color_tallo

    print_char_in_pos_color 20,25,219,color_tallo
    print_char_in_pos_color 20,26,219,color_tallo
    print_char_in_pos_color 20,27,219,color_tallo

    print_char_in_pos_color 21,25,219,color_tallo
    print_char_in_pos_color 21,26,219,color_tallo
    print_char_in_pos_color 21,27,219,color_tallo

    print_char_in_pos_color 22,25,219,color_tallo
    print_char_in_pos_color 22,26,219,color_tallo
    print_char_in_pos_color 22,27,219,color_tallo

    print_char_in_pos_color 23,26,219,color_tallo
    print_char_in_pos_color 23,27,219,color_tallo
    print_char_in_pos_color 23,28,219,color_tallo

    print_char_in_pos_color 24,26,219,color_tallo
    print_char_in_pos_color 24,27,219,color_tallo
    print_char_in_pos_color 24,28,219,color_tallo
     RET
paint_screen ENDP

paint_background PROC NEAR
    PUSH CX         ; Save CX register
    MOV row, 0      ; Start from row 0
row_loop:
    MOV col, 0      ; Start from column 0
col_loop:
    MOV DH, row
    MOV DL, col
    print_char_in_pos_color DH, DL, 219, color_fondo
    INC col
    MOV DL, col
    CMP DL, 80      ; Screen width (80 columns)
    JL col_loop
    INC row
    MOV DH, row
    CMP DH, 25      ; Screen height (25 rows)
    JL row_loop
    POP CX          ; Restore CX register
    RET
paint_background ENDP

end_program:
    MOV AX, 4C00h
    INT 21h
end inicio