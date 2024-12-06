gx_x      dw ?      ; Coordenada X
gx_y      dw ?      ; Coordenada Y
gx_x1     dw ?      ; Coordenada X inicial
gx_y1     dw ?      ; Coordenada Y inicial
gx_x2     dw ?      ; Coordenada X final
gx_y2     dw ?      ; Coordenada Y final
gx_dx     dw ?      ; Delta X (diferencia en X)
gx_dy     dw ?      ; Delta Y (diferencia en Y)
gx_m      dw ?      ; Pendiente (para cálculo de lineas)
gx_color  db ?      ; Color del pixel

; Establece el modo de video del BIOS de MS-DOS
gx_set_video_mode macro mode
  mov al, mode     ; Modo de video
  mov ah, 0        ; Función para establecer modo de video
  int 10h          ; Interrupción de video
endm

; Dirección inicial de la memoria de video
GX_START_ADDR dw 0a000h

; Modo de video
; a 320x200 con 256 colores (MCGA, VGA)
; { Usa ES }
; TODO: Hace falta decidir que modo usar
gx_set_video_mode_gx macro
  gx_set_video_mode 13h      ; Modo grqfico 320x200
  mov es, GX_START_ADDR      ; Segmento de memoria de video
endm

; Establece explicitamente el modo de video del BIOS de MS-DOS
; a texto monocromatico de 80x25 (MDA, HERC, EGA, VGA)
gx_set_video_mode_txt macro
  gx_set_video_mode 03h      ; Modo texto 80x25
endm

; Dibuja un pixel usando la API del BIOS (int 10h) { Usa AX, CX, DX }
gx_pixel_bios macro x, y, color
  mov ah, 0CH      ; Funcirn del BIOS para dibujar pixel grafico
  mov al, color    ; AL almacena el color
  mov cx, x        ; CX almacena la coordenada X
  mov dx, y        ; DX almacena la coordenada Y
  int 10h          ; Llamada a la interrupción del BIOS
endm

; Dibuja un pixel usando la memoria de video { Usa AX, BX, DI, Memoria de video }
gx_pixel macro x, y, color
  mov ax, y         ; AX = coordenada Y
  mov bx, 320       ; 320 píxeles por fila
  mul bx            ; Multiplica Y por 320
  mov di, ax        ; DI = posición en la memoria
  add di, x         ; Agrega X para obtener la posición exacta
  mov al, color     ; AL almacena el color
  mov es:[di], al   ; Escribe el color en la memoria de video
endm
