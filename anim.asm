.model small
.code
.386
.stack 128

include libg.asm

org 100h

x  dw ?
y  dw ?
xd dw ?
yd dw ?
msg db "Presiona <ESC> para salir"

public Programa_Burbuja
Programa_Burbuja PROC NEAR
start:
	gx_set_video_mode_gx

	; Inicializa el programa
	mov x, 270	; Centro en 150
	mov y, 30	; Centro en 90
	mov xd, 1   ; La dirección inicial en X es negativa
	mov yd, 0   ; La dirección inicial en Y es positiva
	mov gx_color, 32

mainloop:
	; Verifica si se presionó la tecla ESCAPE
	call check_keypress
	jz draw 	; No hay tecla presionada
	cmp al, 27 	; Verifica si el código ASCII de la tecla es 27 (ESC)
	je exit		; Si es así, salir del programa

draw:

	; Limpia el cuadro anterior
	mov dh, gx_color ; Almacena temporalmente el color original
	push dx
	mov gx_color, 17
	call gx_rect
	pop dx
	mov gx_color, dh ; Restaura el color original

	movv gx_x1, x
	movv gx_y1, y
	movv gx_x2, gx_x1
	movv gx_y2, gx_y1
	add gx_x2, 20
	add gx_y2, 20
	call gx_rect

	; Pausa por 2048 microsegundos
	mov     cx, 00000h
	mov     dx, 05800h
	mov     ah, 86H
	int     15H

	; Cambia la dirección en X
	cmp x, 300
	jge	setxdec
	jmp setxdecelse
setxdec:
	mov xd, 1
setxdecelse:

	cmp x, 0
	jle setxinc
	jmp setxincelse
setxinc:
	mov xd, 0
setxincelse:

	; Cambia la dirección en Y
	cmp y, 180
	jge	setydec
	jmp setydecelse
setydec:
	mov yd, 1
setydecelse:

	cmp y, 0
	jle setyinc
	jmp setyincelse
setyinc:
	mov yd, 0
setyincelse:

	; Incrementa o decrementa X según la dirección en X
	cmp xd, 1
	je xdec
	inc x
	jmp xelse
xdec:
	dec x
xelse:

	; Incrementa o decrementa Y según la dirección en Y
	cmp yd, 1
	je ydec
	inc y
	jmp yelse
ydec:
	dec y
yelse:

	jmp mainloop

exit:
	gx_set_video_mode_txt
	ret


Programa_Burbuja ENDP

end start



END
