section .data
    msg db "Hello, World",10,0
    len equ $-msg

section .text
    GLOBAL _start
    EXTERN write
    EXTERN exit

_start:

    push len 		
    push msg		
    call write
    add esp, 8		; limpio los 2 parametros

    mov ebx, 0 		; pongo 0 en ebx para que exit(0)
    call exit		
