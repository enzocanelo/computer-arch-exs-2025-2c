section .data
  msg db "h4ppy c0d1ng",10,0


section .text
  GLOBAL _start
  EXTERN print
  EXTERN exit

_start:
  push ebp
  mov ebp, esp
  push ebx
  push eax

  mov ebx, msg

  .loop:
    mov al, [ebx]
    cmp al, 0
    jz .done
    
    cmp al, 'a'
    jl .next
    
    cmp al, 'z'
    jg .next

    sub al, 32
    mov [ebx], al

  .next:
    inc ebx
    jmp .loop

  .done:
  mov ebx, msg
  call print

  xor ebx, ebx
  call exit
  
  pop eax
  pop ebx
  mov esp, ebp
  pop ebp
  ret

    

