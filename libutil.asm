; Mueve datos de una variable a otra variable
movv macro to, from
  push from
  pop to
endm

; Compara dos variables de memoria
cmpv macro var1, var2, register
  mov register, var1
  cmp register, var2
endm

; Suma dos variables de memoria
addv macro to, from, register
  mov register, to
  add register, from
  mov to, register
endm

; Resta dos variables de memoria
subv macro to, from, register
  mov register, to
  sub register, from
  mov to, register
endm

; Devuelve el control al DOS
return macro code
  mov ah, 4ch
  mov al, code
  int 21h
endm

; Guarda registros en la pila
save_registers macro
  push ax
  push bx
  push cx
  push dx
endm

; Restaura registros desde la pila
restore_registers macro
  pop dx
  pop cx
  pop bx
  pop ax
endm

; Verifica si hay una tecla presionada; Establece ZF si no hay tecla disponible
; De lo contrario, devuelve su código de escaneo en AH y su ASCII en AL
; Elimina el carácter del "Type Ahead Buffer" { USANDO AX }
check_keypress:
  mov ah, 1     ; Verifica si hay un carácter en el "Type Ahead Buffer"
  int 16h       ; Interrupción de servicios de teclado BIOS de MS-DOS
  jz check_keypress_empty
  mov ah, 0
  int 16h
  ret
check_keypress_empty:
  cmp ax, ax    ; Establece explícitamente el ZF
  ret
