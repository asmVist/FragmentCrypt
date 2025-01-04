section .data
    prompt db 'Type a string to encrypt ~# ', 0
    prompt_len equ $ - prompt
    key_prompt db 'Type a single byte key ~# ', 0
    key_prompt_len equ $ - key_prompt
    encrypted_string db 'Encrypted string ~# ', 0
    encrypted_string_len equ $ - encrypted_string
    newline db 10, 0

section .bss
    input_buffer resb 256
    encrypted_buffer resb 256
    key resb 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 256
    int 0x80

    mov byte [input_buffer + eax - 1], 0

    ; Pprompt
    mov eax, 4
    mov ebx, 1
    mov ecx, key_prompt
    mov edx, key_prompt_len
    int 0x80

    ; read the key
    mov eax, 3
    mov ebx, 0
    mov ecx, key
    mov edx, 1
    int 0x80

    ; XOR encryption loop
    mov ebx, input_buffer
    mov esi, encrypted_buffer
    xor ecx, ecx

encrypt_loop:
    movzx edx, byte [ebx + ecx]
    cmp dl, 0
    je encryption_done

    xor dl, [key]
    mov [esi + ecx], dl
    inc ecx
    jmp encrypt_loop

encryption_done:
    mov byte [esi + ecx], 0

    ; encrypted string disply
    mov eax, 4
    mov ebx, 1
    mov ecx, encrypted_string
    mov edx, encrypted_string_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, encrypted_buffer
    mov edx, ecx
    int 0x80

    ; newlinee
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit close FragmentCrypt
    mov eax, 1
    xor ebx, ebx
    int 0x80