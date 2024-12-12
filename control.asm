;Macros
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

;-----
.MODEL SMALL
.386
.STACK 100H

.DATA
    Menu_Title DB 09, "Mueve el cuadrito", '$'
    Menu_Decoracion DB "==================================", '$' 
    Menu_Controles DB "Controles: ", '$'
    Menu_Up DB "W - Mover hacia arriba", '$'
    Menu_Down DB "A - Mover hacia abajo" , '$'
    Menu_Left DB "S - Mover hacia la izquierda", '$'
    Menu_Right DB "D - Mover hacia la derecha", '$'
    Menu_Continue DB "Presiona <ENTER> para continuar", '$'
    posX DB 0 
    posY DB 0
    pressedKey DB ?

.CODE 
public Programa_Control

Programa_Control PROC NEAR


    cln_screen

    ; This hides the cursor
    mov ah, 01h
    mov cx, 2607h
    int 10h

    call show_controls_menu 
    MOV AH, 00h
    INT 16h  

    cln_screen
    jmp main_loop
    ; print_char_in_pos_color 13, 36, 219, 10

Programa_Control ENDP

main_loop:
    ; Draw square in posX, posY
    MOV AH, [posY]
    MOV AL, [posX]
    print_char_in_pos_color [posY], [posX], 219, 10


    ; Clear previous position
    ; MOV AL, [posY]
    ; MOV AH, [posX]
    ; cln_screen

    ; Sleep for 2048 microseconds
    ; MOV CX, 0000h
    ; MOV DX, 0580h
    ; MOV AH, 86H
    ; INT 15H

    ; Read key
    MOV AH, 00h
    INT 16h
    MOV [pressedKey], AL
    ; cln_screen
    MOV AH, [posY]
    MOV AL, [posX]
    print_char_in_pos [posY], [posX], ' '  ; Replace with a space to "erase" character
    MOV AL, [pressedKey]

    ; Check key press
    CMP AL, 'w';w
    JE move_up

    CMP AL, 'a';a
    JE move_left

    CMP AL, 73h;'s';s
    JE move_down

    CMP AL, 'd';s
    JE move_right

    CMP AL, 1Bh;ESC
    JE terminate

    JMP main_loop

move_up:
    CMP [posY], 1       ; Check upper boundary
    JLE main_loop
    DEC [posY]
    JMP main_loop

move_down:
    CMP [posY], 23      ; Check lower boundary
    JGE main_loop
    INC [posY] 
    JMP main_loop

move_left:
    CMP [posX], 1       ; Check left boundary
    JLE main_loop
    DEC [posX] 
    JMP main_loop

move_right:
    CMP [posX], 78      ; Check right boundary
    JGE main_loop
    INC [posX] 
    JMP main_loop


terminate:
    set_video_mode 03h
    RET

show_controls_menu PROC NEAR
    print_string_in_pos 1, 25, Menu_Title
    print_string_in_pos 2, 25, Menu_Decoracion
    print_string_in_pos 4, 35, Menu_Controles
    print_string_in_pos 6, 25, Menu_Up 
    print_string_in_pos 7, 25, Menu_Down
    print_string_in_pos 8, 25, Menu_Left
    print_string_in_pos 9, 25, Menu_Right
    print_string_in_pos 11, 25, Menu_Continue
    RET
show_controls_menu ENDP

END