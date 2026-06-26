section .data
    ; Mensagens globais do sistema
    msg1 db 'Bem-vindo. Digite seu nome: ', 0
    len_msg1 equ $ - msg1

    msg2 db 'Hola, ', 0
    len_msg2 equ $ - msg2

    msg3 db ', bem-vindo ao programa de CALC IA-32', 10, 0
    len_msg3 equ $ - msg3

    msg4 db 10, 'Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32): ', 0
    len_msg4 equ $ - msg4

    ; menu
    msg5 db 10, 'ESCOLHA UMA OPÇÃO:', 10, 0
    len_msg5 equ $ - msg5

    msg_menu1 db ' 1: SOMA', 10, 0
    len_menu1 equ $ - msg_menu1

    msg_menu2 db ' 2: SUBTRAÇÃO', 10, 0
    len_menu2 equ $ - msg_menu2

    msg_menu3 db ' 3: MULTIPLICAÇÃO', 10, 0
    len_menu3 equ $ - msg_menu3

    msg_menu4 db ' 4: DIVISÃO', 10, 0
    len_menu4 equ $ - msg_menu4

    msg_menu5 db ' 5: EXPONENCIAÇÃO', 10, 0
    len_menu5 equ $ - msg_menu5

    msg_menu6 db ' 6: MOD', 10, 0
    len_menu6 equ $ - msg_menu6

    msg_menu7 db ' 7: SAIR', 10, 'Opção: ', 0
    len_menu7 equ $ - msg_menu7

section .bss
    ; variaveis globais
    nome resb 50        ; reserva 50 bytes pro nome
    precisao resb 2     ; reserva espaço pra precisão (0 ou 1 + ENTER)
    opcao resb 2        ; reserva espaço pra opção do menu

section .text
    global _start

    global print
    global print16
    global print32
    global input16
    global input32

    extern soma
    extern subtracao
    extern multiplicacao

_start:
    ; programa principal

    ; imprime msg1 (nome do usuário)
    push len_msg1   ; empilha tamanho da string
    push msg1       ; empilha o ponteiro da string
    call print      ; chama função
    add esp, 8      ; limpa pilha

    ; lê nome
    push 50         ; empilha tamanho máximo
    push nome       ; empilha variável global 'nome'
    call input      ; chama função
    add esp, 8      ; limpa pilha
    push eax        ; salva tamanho exato do nome na pilha

    ; imprime msg2 (boas vindas/1)
    push len_msg2
    push msg2
    call print
    add esp, 8

    ; imprime nome digitado
    pop eax         ; tira o tamanho salvo na pilha e volta pro eax
    dec eax         ; -1 byte do ENTER 

    push eax        ; empilha tamanho
    push nome       ; empilha ponteiro do nome
    call print
    add esp, 8

    ; imprime msg3 (boas vindas/2)
    push len_msg3
    push msg3
    call print
    add esp, 8

    ; imprime msg4 (precisao)
    push len_msg4
    push msg4
    call print
    add esp, 8

    ; lê precisao
    push 2
    push precisao
    call input
    add esp, 8

loop_menu:
    ; imprime msg5 (menu)
    push len_msg5
    push msg5
    call print
    add esp, 8

    ; imprime opções do menu
    push len_menu1
    push msg_menu1
    call print
    add esp, 8

    push len_menu2
    push msg_menu2
    call print
    add esp, 8

    push len_menu3
    push msg_menu3
    call print
    add esp, 8

    push len_menu4
    push msg_menu4
    call print
    add esp, 8

    push len_menu5
    push msg_menu5
    call print
    add esp, 8

    push len_menu6
    push msg_menu6
    call print
    add esp, 8

    push len_menu7
    push msg_menu7
    call print
    add esp, 8

    ; lê a opção do menu
    push 2
    push opcao
    call input
    add esp, 8
    mov al, [opcao] ; carrega o caractere digitado

    cmp al, '1'     ; usuário escolheu soma?
    je call_soma

    cmp al, '2'    ; usuário escolheu subtração?
    je call_sub

    cmp al, '3'    ; usuário escolheu multiplicação?
    je call_mul

    ;cmp al, '4'    ; usuário escolheu divisão?
    ;je call_div

    ;cmp al, '5'    ; usuário escolheu exponenciação?
    ;je call_exp

    ;cmp al, '6'    ; usuário escolheu mod?
    ;je call_mod

    cmp al, '7'     ; usuário escolheu sair?
    je fim_programa

    jmp loop_menu

call_soma:
    mov al, [precisao]
    sub al, '0'         ; converte o caractere '0'/'1' para número
    movzx eax, al       ; garante que o resto do registrador está zerado
    push eax            ; empilha a precisão

    call soma           ; pula pro arquivo SOMA.ASM
    add esp, 4          ; limpa parâmetro da pilha

    ; buffer temporário para segurar o programa até que o usuário aperte ENTER
    push 2
    push opcao
    call input
    add esp, 8
    jmp loop_menu       ; retorna pro menu

call_sub:
    mov al, [precisao]
    sub al, '0'         ; converte o caractere '0'/'1' para número
    movzx eax, al       ; garante que o resto do registrador está zerado
    push eax            ; empilha a precisão

    call subtracao      ; pula pro arquivo SUBTRACAO.ASM
    add esp, 4          ; limpa parâmetro da pilha

    ; buffer temporário para segurar o programa até que o usuário aperte ENTER
    push 2
    push opcao
    call input
    add esp, 8
    jmp loop_menu       ; retorna pro menu

call_mul:
    mov al, [precisao]
    sub al, '0'         ; converte o caractere '0'/'1' para número
    movzx eax, al       ; garante que o resto do registrador está zerado
    push eax            ; empilha a precisão

    call multiplicacao  ; pula pro arquivo MULTIPLICACAO.ASM
    add esp, 4          ; limpa parâmetro da pilha

    ; buffer temporário para segurar o programa até que o usuário aperte ENTER
    push 2
    push opcao
    call input
    add esp, 8
    jmp loop_menu       ; retorna pro menu

fim_programa:
    ; fim do programa
    mov eax, 1      ; syscall de exit
    mov ebx, 0      ; codigo de retorno
    int 0x80

print:
    push ebp        ; salva o base pointer atual
    mov ebp, esp    ; atualiza

    mov eax, 4          ; syscall pra write
    mov ebx, 1          ; saída padrão
    mov ecx, [ebp + 8]  ; ponteiro string
    mov edx, [ebp + 12] ; tamanho string
    int 0x80            ; chamada kernel

    pop ebp     ; restaura o base pointer
    ret         ; retorna

input:
    push ebp
    mov ebp, esp

    mov eax, 3          ; syscall pra read
    mov ebx, 0          ; entrada padrão
    mov ecx, [ebp + 8]  ; ponteiro do buffer
    mov edx, [ebp + 12] ; tamanho máximo
    int 0x80        

    pop ebp
    ret

input16:
    push ebp
    mov ebp, esp

    ; lê a entrada
    sub esp, 8          ; aloca 8 bytes na pilha
    mov eax, 3          ; syscall pra read
    mov ebx, 0          ; entrada padrão
    lea ecx, [ebp-8]    ; ponteiro pra variável local
    mov edx, 7          ; tamanho máximo
    int 0x80

    ; prepara a conversão
    mov ecx, eax        ; ecx guarda a quantidade de bytes lidos
    lea esi, [ebp-8]    ; esi aponta pro inicio do texto 
    xor eax, eax        ; eax vai somar no resultado final
    xor ebx, ebx        ; ebx vai guardar cada digito individualmente
    mov di, 1           ; di vai guardar o sinal (1 = positivo, -1 = negativo)

    ; verifica se é negativo
    cmp byte [esi], '-'
    jne .loop_conversao16
    mov di, -1          ; muda o sinal pra negativo
    inc esi             ; pula o caractere '-'
    dec ecx             ; diminui a quantidade de bytes a processar

.loop_conversao16:
    mov bl, [esi]       ; pega 1 caractere
    cmp bl, 10          ; é ENTER?
    je .fim_conversao16   
    cmp bl, '0'         ; é < '0'?
    jl .fim_conversao16
    cmp bl, '9'         ; é > '9'?
    jg .fim_conversao16

    ; (acumulado*10) + dígito
    sub bl, '0'         ; converte ASCII para número real
    mov dx, 10         
    mul dx              ; ax = ax*10
    add ax, bx          ; soma o dígito atual

    inc esi             ; avança pro próximo caractere
    dec ecx             ; diminui o contador
    jnz .loop_conversao16

.fim_conversao16:
    imul ax, di         ; multiplica pelo sinal (1 ou -1)
    movsx eax, ax       ; estendo o resultado pra preencher corretamento o eax
    mov esp, ebp        ; limpa as variáveis locais
    pop ebp
    ret                 ; retorna com número pronto no eax

input32:
    push ebp
    mov ebp, esp

    ; lê a entrada
    sub esp, 16         ; aloca 16 bytes na pilha
    mov eax, 3          ; syscall pra read
    mov ebx, 0          ; entrada padrão
    lea ecx, [ebp-16]   ; ponteiro pra variável local
    mov edx, 15         ; tamanho máximo
    int 0x80

    ; prepara a conversão
    mov ecx, eax        ; ecx guarda a quantidade de bytes lidos
    lea esi, [ebp-16]   ; esi aponta pro inicio do texto 
    xor eax, eax        ; eax vai somar no resultado final
    xor ebx, ebx        ; ebx vai guardar cada digito individualmente
    mov edi, 1          ; edi vai guardar o sinal (1 = positivo, -1 = negativo)

    ; verifica se é negativo
    cmp byte [esi], '-'
    jne .loop_conversao32
    mov edi, -1         ; muda o sinal pra negativo
    inc esi             ; pula o caractere '-'
    dec ecx             ; diminui a quantidade de bytes a processar

.loop_conversao32:
    mov bl, [esi]       ; pega 1 caractere
    cmp bl, 10          ; é ENTER?
    je .fim_conversao32   
    cmp bl, '0'         ; é < '0'?
    jl .fim_conversao32
    cmp bl, '9'         ; é > '9'?
    jg .fim_conversao32

    ; (acumulado*10) + dígito
    sub bl, '0'         ; converte ASCII para número real
    mov edx, 10         
    mul edx             ; eax = eax*10
    add eax, ebx        ; soma o dígito atual

    inc esi             ; avança pro próximo caractere
    dec ecx             ; diminui o contador
    jnz .loop_conversao32

.fim_conversao32:
    imul eax, edi       ; multiplica pelo sinal (1 ou -1)
    mov esp, ebp        ; limpa as variáveis locais
    pop ebp
    ret                 ; retorna com número pronto no eax

print16:
    push ebp
    mov ebp, esp

    sub esp, 8          ; aloca 8 bytes na pilha
    mov eax, [ebp+8]    ; pega o parâmetro
    lea ecx, [ebp-1]    ; ecx aponta pro fim do buffer
    mov byte [ecx], 10  ; coloca quebra de linha no final
    dec ecx

    mov di, 0           ; sinal negativo? (0 = não, 1 = sim)
    cmp ax, 0
    jge .prepara_divisao16
    neg ax              ; transforma em positivo pra dividir
    mov di, 1           ; marca a flag como negativa

.prepara_divisao16:
    mov bx, 10          ; vai dividir por 10

.loop_divisao16:
    xor dx, dx          ; zera o edx
    div bx              ; eax = eax/10
    add dl, '0'         ; converte pra caractere
    mov [ecx], dl       ; salva o caractere no buffer
    dec ecx             ; anda pra trás no buffer
    cmp ax, 0           ; acabou o número?
    jnz .loop_divisao16

    ; adiciona sinal negativo se precisar
    cmp di, 1
    jne .call_print16
    mov byte [ecx], '-'
    dec ecx

.call_print16:
    inc ecx             ; aponta pro primeiro caractere
    lea edx, [ebp]      ; calcula o tamanho da string
    sub edx, ecx        ; edx = tamanho da string

    push edx            ; empilha tamanho   
    push ecx            ; empilha ponteiro
    call print          
    add esp, 8          ; limpa pilha

    mov esp, ebp        ; limpa variáveis locais
    pop ebp
    ret

print32:
    push ebp
    mov ebp, esp

    sub esp, 16         ; aloca 16 bytes na pilha
    mov eax, [ebp+8]    ; pega o parâmetro
    lea ecx, [ebp-1]    ; ecx aponta pro fim do buffer
    mov byte [ecx], 10  ; coloca quebra de linha no final
    dec ecx

    mov edi, 0          ; sinal negativo? (0 = não, 1 = sim)
    cmp eax, 0
    jge .prepara_divisao32
    neg eax             ; transforma em positivo pra dividir
    mov edi, 1          ; marca a flag como negativa

.prepara_divisao32:
    mov ebx, 10         ; vai dividir por 10

.loop_divisao32:
    xor edx, edx        ; zera o edx
    div ebx             ; eax = eax/10
    add dl, '0'         ; converte pra caractere
    mov [ecx], dl       ; salva o caractere no buffer
    dec ecx             ; anda pra trás no buffer
    cmp eax, 0          ; acabou o número?
    jnz .loop_divisao32

    ; adiciona sinal negativo se precisar
    cmp edi, 1
    jne .call_print32
    mov byte [ecx], '-'
    dec ecx

.call_print32:
    inc ecx             ; aponta pro primeiro caractere
    lea edx, [ebp]      ; calcula o tamanho da string
    sub edx, ecx        ; edx = tamanho da string

    push edx            ; empilha tamanho   
    push ecx            ; empilha ponteiro
    call print          
    add esp, 8          ; limpa pilha

    mov esp, ebp        ; limpa variáveis locais
    pop ebp
    ret