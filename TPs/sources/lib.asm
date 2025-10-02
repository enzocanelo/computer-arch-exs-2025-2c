GLOBAL write
GLOBAL exit

section .data
	new_line db 10,0

section .text

;===============================================================================
; write - imprime una cadena en la salida estandar. Es mas eficiente que print, 
; pero requiere mas argumentos, no usa los registros.
;===============================================================================
; Argumentos (En orden de pusheo):
;	stack: largo de la cadena
;	stack: cadena a imprimir en pantalla
;===============================================================================

write: 
	push ebp
	mov ebp, esp

	pushad

	mov ecx, [ebp+8]
	mov edx, [ebp+12]

	mov ebx, 1
	mov eax, 4
	int 0x80

	popad

	mov esp, ebp
	pop ebp

	ret

;===============================================================================
; exit - termina el programa
;===============================================================================
; Argumentos:
;	ebx: valor de retorno al sistema operativo
;===============================================================================
exit:
	mov eax, 1	  ; ID del Syscall EXIT
	int 80h	          ; Ejecucion de la llamada

