include libutil.asm

gx_x      dw ?
gx_y      dw ?
gx_x1     dw ?
gx_y1     dw ?
gx_x2     dw ?
gx_y2     dw ?
gx_dx     dw ?
gx_dy     dw ?
gx_m      dw ?
gx_color  db ?

; establece el modo de video
gx_set_video_mode macro mode
  mov al, mode
  mov ah, 0
  int 10h
endm

; dirección de la memoria de video
GX_START_ADDR dw 0a000h

; establece el modo de video a gráficos de 320x200 con 256 colores (MCGA, VGA)
; { Usa ES }
gx_set_video_mode_gx macro
  gx_set_video_mode 13h
  mov es, GX_START_ADDR
endm

; establece el modo de video a texto monocromático de 80x25 (predeterminado) (MDA, HERC, EGA, VGA)
gx_set_video_mode_txt macro
  gx_set_video_mode 03h
endm

; establece un píxel usando la API de BIOS int10h { Usa AX, CX, DX }
gx_pixel_bios macro x, y, color
  mov ah, 0CH     ; función DOS para establecer píxel gráfico
  mov al, color   ; al almacena el color
  mov cx, x       ; cx almacena la coordenada x
  mov dx, y       ; dx almacena la coordenada y
  int 10h         ; interrupción
endm

; establece un píxel usando la memoria de video { Usa AX, BX, DI, Memoria de Video }
gx_pixel macro x, y, color
  mov ax, y
  mov bx, 320
  mul bx
  mov di, ax
  add di, x
  mov al, color
  mov es:[di], al
endm

; dibuja un rectángulo entre (gx_x1; gx_y1) y (gx_x2; gx_y2) { Usa AX, BX, DI, Memoria de Video }
gx_rect:
  movv gx_y, gx_y1
gx_rect_v:
  movv gx_x, gx_x1
gx_rect_h:
  gx_pixel gx_x, gx_y, gx_color
  inc gx_x
  cmpv gx_x, gx_x2, ax
  jl gx_rect_h
  inc gx_y
  cmpv gx_y, gx_y2, ax
  jl gx_rect_v
  ret
