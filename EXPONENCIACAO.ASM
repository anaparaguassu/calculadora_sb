section .data
    msg_exp1 db 'Digite a base: ', 0
    len_exp1 equ $ - msg_exp1

    msg_exp2 db 'Digite o expoente: ', 0
    len_exp2 equ $ - msg_exp2

    msg_res db 'Resultado da exponenciacao: ', 0
    len_res equ $ - msg_res

    ; Mensagem de overflow
    msg_over db 'OCORREU OVERFLOW.', 10, 0
    len_over equ $ - msg_over

section .text
    global exponenciacao

    extern print
    extern print16
    extern print32
    extern input16
    extern input32

exponenciacao:
    push ebp
    mov ebp, esp
    sub esp, 8              ; aloca 8 bytes na pilha para guardar n1 e n2

    ; lê o n1 = [ebp-4]
    push len_exp1
    push msg_exp1
    call print
    add esp, 8

    mov eax, [ebp+8]
    cmp eax, 0              ; verifica precisão (0 = 16 bits, 1 = 32 bits)
    je .ler_n1_16
    call input32
    jmp .salva_n1

.ler_n1_16:
    call input16

.salva_n1:
    mov [ebp-4], eax        ; salva o na variável local

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

    mov eax, [ebp+8]
    cmp eax, 0
    je .exp_16

.exp_32:
    mov ecx, [ebp-8]        ; ecx = contador (expoente)
    mov ebx, [ebp-4]        ; ebx = base
    mov eax, 1              ; eax = resultado acumulado começando em 1

    cmp ecx, 0
    je .print_resultado     ; se expoente = 0, resultado = 1
    jl .exp_negativo_32     ; se expoente < 0

.loop_exp_32:
    imul eax, ebx           ; acumulador*base
    jo .trata_overflow      ; se estourar, overflow 
    dec ecx                 ; diminui contador
    jnz .loop_exp_32        ; se ecx > 0, volta pro loop
    jmp .print_resultado

.exp_negativo_32:
    mov eax, 0              ; se expoente < 0 em inteiros, resultado = 0
    jmp .print_resultado    

.exp_16:
    mov cx, [ebp-8]         ; cx = contador (expoente)
    mov bx, [ebp-4]         ; bx = base
    mov ax, 1               ; ax = resultado acumulado começando em 1

    cmp cx, 0               
    je .extende_16          ; se expoente = 0, resultado = 1
    jl .exp_negativo_16     ; se expoente < 0

.loop_exp_16:
    imul ax, bx             ; acumulador*base
    jo .trata_overflow      ; se estourar, overflow
    dec cx                  ; diminui contador
    jnz .loop_exp_16        ; se cx > 0, volta pro loop
    jmp .extende_16

.exp_negativo_16:
    mov ax, 0               ; se expoente < 0 em inteiros, resultado = 0

.extende_16:
    movsx eax, ax           ; estende o resultado final de ax pra eax
    jmp .print_resultado

.trata_overflow:
    ; printa mensagem de erro - overflow
    push len_over
    push msg_over
    call print
    add esp, 8

    ; força o encerramento do programa com a syscall de exit
    mov eax, 1
    mov ebx, 1
    int 0x80

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