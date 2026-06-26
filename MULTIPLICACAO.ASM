section .data
    ; Mensagens específicas da operação multiplicação
    msg_mul1 db 'Digite o primeiro número: ', 0
    len_mul1 equ $ - msg_mul1

    msg_mul2 db 'Digite o segundo número: ', 0
    len_mul2 equ $ - msg_mul2

    msg_res db 'Resultado da multiplicação: ', 0
    len_res equ $ - msg_res

    ; Mensagem exigida pela especificação
    msg_over db 'OCORREU OVERFLOW.', 10, 0
    len_over equ $ - msg_over

section .text
    global multiplicacao

    extern print
    extern print16
    extern print32
    extern input16
    extern input32

multiplicacao:
    push ebp
    mov ebp, esp
    sub esp, 8          ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_mul1
    push msg_mul1
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
    push len_mul2
    push msg_mul2
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

    ; operação de multiplicação reipeitando a precisão
    mov eax, [ebp+8]
    cmp eax, 0
    je .mul_16

.mul_32:
    mov eax, [ebp-4]
    imul eax, [ebp-8]       ; multiplica e resultado fica em eax
    jo .trata_overflow      ; se estourar o limite de 32 bits, pula pra erro
    jmp .print_resultado

.mul_16:
    mov ax, [ebp-4]
    imul ax, word [ebp-8]   ; como exige 16 bits pegamos a parte baixa (word) da memória
    jo .trata_overflow      ; se estourar 16 bits, pula pra erro
    movsx eax, ax           ; estende pra 32 bits para printar
    jmp .print_resultado

.trata_overflow:

.print_resultado: