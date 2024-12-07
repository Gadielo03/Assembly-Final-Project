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

print_menu MACRO menu_op 
    cln_screen
    print_string_in_pos 1,25,menu_op
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

    

    print_menu Menu_Opcion1
    call validate_color
    MOV color_petalos, AL

    print_menu Menu_Opcion2
    call validate_color
    MOV color_centro, AL

    print_menu Menu_Opcion3
    call validate_color
    MOV color_tallo, AL

    print_menu Menu_Opcion4
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
    print_string_in_pos 0, 25, Menu_Tittle
    print_string_in_pos 2, 25, color_negro
    print_string_in_pos 3, 25, color_azul
    print_string_in_pos 4, 25, color_verde
    print_string_in_pos 5, 25, color_cyan
    print_string_in_pos 6, 25, color_rojo
    print_string_in_pos 7, 25, color_magenta
    print_string_in_pos 8, 25, color_marron
    print_string_in_pos 9, 25, color_gris_claro
    print_string_in_pos 10, 25, color_gris_oscuro
    print_string_in_pos 11, 25, Seleccion_Opcion
    RET
show_color_menu ENDP

validate_color PROC NEAR
color_validator_start:
    print_char_in_pos 11,47,' '
    positionate_cursor 11,47
    read_char
    SUB AL,'0'
    CMP AL, 0
    JL color_validator_start
    CMP AL, 9
    JG color_validator_start
    RET
validate_color ENDP

paint_screen PROC NEAR
    ; Draw outer petals layer
    print_char_in_pos_color 8, 38, 219, color_petalos
    print_char_in_pos_color 16, 38, 219, color_petalos
    print_char_in_pos_color 12, 34, 219, color_petalos
    print_char_in_pos_color 12, 42, 219, color_petalos

    ; Draw middle petals layer
    print_char_in_pos_color 9, 37, 219, color_petalos
    print_char_in_pos_color 9, 39, 219, color_petalos
    print_char_in_pos_color 15, 37, 219, color_petalos
    print_char_in_pos_color 15, 39, 219, color_petalos
    print_char_in_pos_color 10, 36, 219, color_petalos
    print_char_in_pos_color 10, 40, 219, color_petalos
    print_char_in_pos_color 14, 36, 219, color_petalos
    print_char_in_pos_color 14, 40, 219, color_petalos

    ; Draw inner petals layer
    print_char_in_pos_color 11, 36, 219, color_petalos
    print_char_in_pos_color 11, 40, 219, color_petalos
    print_char_in_pos_color 13, 36, 219, color_petalos
    print_char_in_pos_color 13, 40, 219, color_petalos
    print_char_in_pos_color 12, 35, 219, color_petalos
    print_char_in_pos_color 12, 41, 219, color_petalos

    ; Draw center (made bigger)
    print_char_in_pos_color 12, 37, 219, color_centro
    print_char_in_pos_color 12, 38, 219, color_centro
    print_char_in_pos_color 12, 39, 219, color_centro
    print_char_in_pos_color 11, 38, 219, color_centro
    print_char_in_pos_color 13, 38, 219, color_centro

    ; Draw stem and leaves (made longer)
    print_char_in_pos_color 17, 38, 219, color_tallo
    print_char_in_pos_color 18, 38, 219, color_tallo
    print_char_in_pos_color 19, 38, 219, color_tallo
    print_char_in_pos_color 20, 38, 219, color_tallo
    print_char_in_pos_color 18, 37, 219, color_tallo
    print_char_in_pos_color 18, 39, 219, color_tallo
    print_char_in_pos_color 19, 36, 219, color_tallo
    print_char_in_pos_color 19, 40, 219, color_tallo
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