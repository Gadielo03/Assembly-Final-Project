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

public Programa_Burbuja
Programa_Burbuja PROC NEAR
start:
	gx_set_video_mode_gx

	; Initialize program
	mov x, 270	; Center at 150
	mov y, 30	; Center at 90
	mov xd, 1   ; Initial X direction is negative
	mov yd, 0   ; Initial Y direction is positive
	mov gx_color, 32

mainloop:
	; Check if ESCAPE key is pressed
	call check_keypress
	jz draw 	; No keypress available
	cmp al, 27 	; Check if ASCII code of key is 27 (ESC)
	je exit		; If so exit the program

draw:
	; Clear the previous square
	mov dh, gx_color ; Temporary storing the original color
	push dx
	mov gx_color, 17
	call gx_rect
	pop dx
	mov gx_color, dh ; Restoring the original color

	movv gx_x1, x
	movv gx_y1, y
	movv gx_x2, gx_x1
	movv gx_y2, gx_y1
	add gx_x2, 20
	add gx_y2, 20
	call gx_rect

	; Sleep for 2048 microseconds
	mov     cx, 00000h
	mov     dx, 05800h
	mov     ah, 86H
	int     15H

	; Change X Direction
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

	; Change Y Direction
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

	; Increment or Decrement X based on X Direction
	cmp xd, 1
	je xdec
	inc x
	jmp xelse
xdec:
	dec x
xelse:

	; Increment or Decrement Y based on Y Direction
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
	

Programa_Burbuja ENDP

end start



END
