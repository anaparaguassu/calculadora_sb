section .data
    ; Mensagens específicas da operação subtração
    msg_sub1 db 'Digite o primeiro número: ', 0
    len_sub1 equ $ - msg_sub1

    msg_sub2 db 'Digite o segundo número: ', 0
    len_sub2 equ $ - msg_sub2

    msg_res db 'Resultado da subtração: ', 0
    len_res equ $ - msg_res

section .text
    global subtracao

    extern print
    extern print16
    extern print32
    extern input16
    extern input32

subtracao:
    push ebp
    mov ebp, esp
    sub esp, 8          ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_sub1
    push msg_sub1
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
    push len_sub2
    push msg_sub2
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

    ; operação de subtração respeitando a precisão
    mov eax, [ebp+8]
    cmp eax, 0
    je .sub_16

.sub_32:
    mov eax, [ebp-4]
    sub eax, [ebp-8]    ; subtração 32 bits
    jmp .print_resultado

.sub_16:
    mov ax, [ebp-4]
    sub ax, [ebp-8]     ; subtração 16 bits
    movsx eax, ax       ; estende para 32 pra imprimir e retornar

.print_resultado:
    push eax            
    push len_res        
    push msg_res
    call print
    add esp, 8

    pop eax             ; recupera resultado salvo
    push eax            ; empilha

    mov ebx, [ebp+8]        
    cmp ebx, 0          ; verifica precisão
    je .print_n16
    call print32
    jmp .fim

.print_n16:
    call print16

.fim:
    pop eax
    mov esp, ebp        ; limpa as variáveis locais
    pop ebp
    ret                 ; retorna pra o menu da calculadora