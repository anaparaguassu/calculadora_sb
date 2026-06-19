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