section .data
    msg_div1 db 'Digite o dividendo: ', 0
    len_div1 equ $ - msg_div1

    msg_div2 db 'Digite o divisor: ', 0
    len_div2 equ $ - msg_div2

    msg_res db 'Resultado da divisao: ', 0
    len_res equ $ - msg_res

section .text
    global divisao

    ; Usando as suas exportações padrão
    extern print
    extern print16
    extern print32
    extern input16
    extern input32

divisao:
    push ebp
    mov ebp, esp
    sub esp, 8          ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_div1
    push msg_div1
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
    push len_div2
    push msg_div2
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

    ; operação de divisão respeitando a precisão
    mov eax, [ebp+8]
    cmp eax, 0
    je .div_16

.div_32:
    mov eax, [ebp-4]        ; coloca dividendo no eax
    cdq                     ; estende sinal de eax pra edx (edx:eax)
    idiv dword [ebp-8]      ; divide pelo divisor, quociente = eax e resto = edx
    jmp .print_resultado

.div_16:
    mov ax, [ebp-4]         ; coloca dividendo no ax
    cwd                     ; estende sinal de ax pra dx (dx:ax)
    idiv word [ebp-8]       ; divide pelo divisor, quociente = ax e resto = dx
    movsx eax, ax           ; estende o quociente pra 32 bits para printar

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