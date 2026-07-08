section .data
    msg_exp1 db 'Digite a base: ', 0
    len_exp1 equ $ - msg_exp1

    msg_exp2 db 'Digite o expoente: ', 0
    len_exp2 equ $ - msg_exp2

    msg_res db 'Resultado da exponenciacao: ', 0
    len_res equ $ - msg_res

    ; Mensagem obrigatória de erro
    msg_over db 'OCORREU OVERFLOW.', 10, 0
    len_over equ $ - msg_over

section .text
    global exponenciacao

    extern imprimir_string
    extern print16
    extern print32
    extern input16
    extern input32

exponenciacao:
    push ebp
    mov ebp, esp
    sub esp, 8          ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_exp1
    push msg_exp1
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
    push len_exp2
    push msg_exp2
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