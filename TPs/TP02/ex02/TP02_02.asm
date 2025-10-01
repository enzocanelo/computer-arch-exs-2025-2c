
bal _start

section .data
str: db "h4ppy c0d1ng", 0


section .text
to_upper:
    .loop:
    	mov al, [rsi]
	cmp al, 0
	je .done

	cmp al, 'a' 
	jb .next
	cmp al, 'Z' 
	ja .next

	sub al, 'a' - 'A' 
	mov [rsi], al

    .next:
    	inc rsi
	jmp .loop

    .done:
    	ret


_start:
	lea rsi, [rel str]
	call to_upper
	mov rax, 1          ; syscall write
	mov rdi, 1          ; fd = stdout
	lea rsi, [rel str]  ; buffer = str
	mov rdx, 12         ; longitud del string (sin el 0 final)
	syscall

