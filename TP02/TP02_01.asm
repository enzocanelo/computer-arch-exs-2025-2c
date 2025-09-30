; hello.asm — NASM (Intel syntax), Linux x86-64
; Escribe "Hello World\n" en stdout y termina.

global _start

section .data
msg:    db "Hello World", 10     ; 10 = '\n'
len:    equ $ - msg		 ; len = $ (position) - msg (msg position)

section .text
_start:
    ; write(1, msg, len)
    mov     rax, 1          ; syscall write
    mov     rdi, 1          ; fd = stdout
    mov     rsi, msg        ; buffer
    mov     rdx, len        ; longitud
    syscall

    ; exit(0)
    mov     rax, 60         ; syscall exit
    xor     rdi, rdi        ; código 0
    syscall

