section .data
    msg_mod1 db 'Digite o dividendo: ', 0
    len_mod1 equ $ - msg_mod1

    msg_mod2 db 'Digite o divisor: ', 0
    len_mod2 equ $ - msg_mod2

    msg_res db 'Resto da divisao (MOD): ', 0
    len_res equ $ - msg_res

section .text
    global modulo

    extern print
    extern print16
    extern print32
    extern input16
    extern input32

modulo:
    push ebp
    mov ebp, esp
    sub esp, 8          ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_mod1
    push msg_mod1
    call print
    add esp, 8

    mov eax, [ebp+8]
    cmp eax, 0          ; verifica precisão (0 = 16 bits, 1 = 32 bits)
    je .ler_n1_16
    call input32
    jmp .salva_n1

.ler_n1_16:
    call input16

.salva_n1:
    mov [ebp-4], eax    ; salva o na variável local

    ; lê o n2 = [ebp-8]
    push len_mod2
    push msg_mod2
    call print
    add esp, 8

    mov eax, [ebp+8]
    cmp eax, 0
    je .ler_n2_16
    call input32
    jmp .salva_n2

.ler_n2_16:
    call input16

.salva_n2:
    mov [ebp-8], eax

    ; operação de MOD respeitando a precisão
    mov eax, [ebp+8]
    cmp eax, 0
    je .mod_16

; a lógica vai ser igual a divisão + mover o resto pro eax
.mod_32:
    mov eax, [ebp-4]        ; coloca dividendo no eax
    cdq                     ; estende sinal de eax pra edx (edx:eax)
    idiv dword [ebp-8]      ; divide pelo divisor, quociente = eax e resto = edx
    mov eax, edx            ; move o resto pro eax
    jmp .print_resultado

.mod_16:
    mov ax, [ebp-4]         ; coloca dividendo no ax
    cwd                     ; estende sinal de ax pra dx (dx:ax)
    idiv word [ebp-8]       ; divide pelo divisor, quociente = ax e resto = dx
    movsx eax, dx           ; move o resto pro eax e estende pra 32 bits para printar

.print_resultado:
    push eax
    push len_res
    push msg_res
    call print 
    add esp, 8

    pop eax
    push eax

    mov ebx, [ebp+8]
    cmp ebx, 0
    je .print_n16
    call print32
    jmp .fim

.print_n16:
    call print16

.fim:
    pop eax
    mov esp, ebp
    pop ebp
    ret