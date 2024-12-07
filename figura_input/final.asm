COMMENT @
	WIP
	Este programa dibuja una figura (posiblemente el resultado final sera un cuadro nada mas)
	y espera input de teclado para moverse (posiblemente seran wasd)
	Actualmente solo se mueve a la derecha 5 veces antes de salir.
@

print MACRO cadena
		mov ah, 09h
		mov dx, offset cadena
		int 21h
ENDM

; Macro para establecer modo de video
set_video_mode MACRO mode 
	mov al, mode
	mov ah, 0
	int 10h
ENDM

; Ejemplo robado de la clase de Arquitectura de computadoras jejj
; NOTA: Cambiar a algo mas sencillo como un simple cuadro, esta madre es muy propensa a romperse
draw_pikachu MACRO primero
    mov dx, primero
    add dl, 0Dh    
    draw_line 07h, primero, dx
	add cl,04h
	draw_line 77h,cx,dx
	add cl,08h
	draw_line 07h,cx,dx
    add ch, 01h
    sub cl, 0Ah
    mov dh, ch   
    draw_line 0E7h, cx, dx
	add cl,02h
	draw_line 67h, cx, dx
	add cl,02h
	draw_line 77h, cx, dx	
	add cl,06h
	draw_line 67h, cx, dx
    add ch, 01h
    sub cl, 08h
    mov dh, ch    
    draw_line 0E7h, cx, dx	
	add cl,08h
	draw_line 67h, cx, dx
    add ch, 01h
    sub cl, 0Eh
    mov dh, ch    
    draw_line 0E7h, cx, dx	
	add cl,02h
	draw_line 77h, cx, dx
	add cl,04h
    draw_line 0E7h, cx, dx	
	add cl,02h
	draw_line 07h, cx, dx
	add cl,02h
	draw_line 0E7h, cx, dx
	add cl,04h
	draw_line 07h, cx, dx
    add ch, 01h
    sub cl, 0Eh
    mov dh, ch    
    draw_line 0E7h, cx, dx	
	add cl,04h
	draw_line 77h, cx, dx
	add cl,02h
    draw_line 0C7h, cx, dx	
	add cl,02h
	draw_line 0E7h, cx, dx
	add cl,06h
	draw_line 67h, cx, dx
    add ch, 01h
    sub cl, 0Ch
    mov dh, ch    
	sub dl,02h
    draw_line 67h, cx, dx	
	add cl,02h
	draw_line 77h, cx, dx
	add cl,02h
    draw_line 0E7h, cx, dx	
	add cl,02h
	draw_line 67h, cx, dx
    add ch, 01h
    sub cl, 06h
    mov dh, ch    
    draw_line 07h, cx, dx	
	add cl,02h
	draw_line 0E7h, cx, dx
	add cl,02h
    draw_line 67h, cx, dx
	add cl,02h
    draw_line 0E7h, cx, dx	
	add cl,02h
    draw_line 67h, cx, dx
	add cl,02h
    draw_line 0E7h, cx, dx
    add ch, 01h
    sub cl, 08h
    mov dh, ch   
    draw_line 0E7h, cx, dx	
	add cl,02h
	draw_line 67h, cx, dx
	add cl,02h
    draw_line 07h, cx, dx
	add cl,04h
    draw_line 67h, cx, dx
ENDM

draw_square MACRO primero, size
    mov cx, primero
    mov dx, cx
    add dl, size

    mov ax, size
squareRow:
    draw_line 0E7h, cx, dx
    add ch, 1
    dec ax
    jnz squareRow
ENDM

datos MACRO 
		mov ax, @Data
		mov ds, ax					
ENDM

draw_line MACRO color, esq1, esq2
		mov ah, 06h
		mov bh, color
		mov cx, esq1
		mov dx, esq2
		int 10h
ENDM

clear_screen MACRO
		draw_line 0F0h, 0000h, 184Fh
ENDM
		
read_key MACRO 
		mov ah, 08h				
		int 21h
ENDM



.MODEL SMALL
.STACK 20h
.DATA
	vCont DB 00h
.CODE
    inicio: 
        datos
        mov al, 00h
        clear_screen
		set_video_mode 03h
        mov cx, 0008h
        push cx
		; draw_square 050Ah, 8 ;TODO: cambiar a un cuadro, actualmente se rompe
        draw_pikachu cx

    eMover:
		inc vCont
        read_key
        clear_screen
        mov al, 00h
        pop cx
        add cx, 0004h	
        push cx
        draw_pikachu cx
		cmp vCont,0Ah
		jae fin
		jmp eMover
		
    fin:
        call exitProgram
    

    exitProgram PROC Near
	; Reset to text mode (80x25)
    set_video_mode 03h

    ; Optionally clear the screen in text mode (if desired)
    mov ah, 06h
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    int 10h

    ; Exit to DOS
    mov ax, 4C00h ; Terminate program with return code 0
    int 21h
    ret
    exitProgram ENDP

END inicio
