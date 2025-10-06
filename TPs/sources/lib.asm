GLOBAL write
GLOBAL exit
GLOBAL print
GLOBAL strlen


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
	int 80h	      ; Ejecucion de la llamada


;===============================================================================
; print - imprime una cadena en la salida estandar
;===============================================================================
; Argumentos:
;	ebx: cadena a imprimir en pantalla, terminada con 0
;===============================================================================
print:
	pushad
	mov ebp, esp

  call strlen
  mov edx, eax
  mov ecx, ebx

  mov ebx, 1    
  mov eax, 4    ; syscall de write(fd -> ebx, buffer -> ecx, length -> edx)
  int 0x80      ; o int 80h ejecucion
  
  mov esp, ebp
  popad
  ret

	
;===============================================================================
; strlen - calcula la longitud de una cadena terminada con 0
;===============================================================================
; Argumentos:
;	ebx: puntero a la cadena
; Retorno:
;	eax: largo de la cadena
;===============================================================================
strlen:
  push ebx
  pushf

  xor eax, eax
  .loop:
    cmp byte [ebx + eax], 0
    jz .done
    inc eax
    jmp .loop

  .done:
    popf
    pop ebx

    ret
  
