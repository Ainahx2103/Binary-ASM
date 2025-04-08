section .data
    prompt db "Enter a binary number: ", 0
    prompt_len equ $ - prompt
    newline db 10
    result_msg db "Decimal: ", 0
    buffer times 32 db 0

section .bss
    input resb 32

section .text
    global _start

_start:
    ; Show prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 32
    syscall
    mov rcx, rax         

    xor rbx, rbx         

parse_loop:
    dec rcx
    js convert_done

    mov al, byte [input + rcx]
    cmp al, 10           
    je parse_loop
    sub al, '0'          
    cmp al, 1
    ja parse_loop        

    shl rbx, 1           
    add rbx, rax        
    jmp parse_loop

convert_done:
    ; Show "Decimal: "
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, 9
    syscall

    ; Convert rbx to string
    mov rsi, buffer + 31
    mov byte [rsi], 0

    mov rax, rbx
    test rax, rax
    jnz convert_loop

    ; handle 0 as special case
    mov byte [rsi - 1], '0'
    dec rsi
    jmp print_result

convert_loop:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz convert_loop

print_result:
    ; Print the result string
    mov rax, 1
    mov rdi, 1
    mov rdx, buffer + 31
    sub rdx, rsi         
    mov rsi, rsi         
    syscall

    ; Newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

