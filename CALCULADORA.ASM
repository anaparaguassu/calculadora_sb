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

section .bss
    ; variaveis globais
    nome resb 50        ; reserva 50 bytes pro nome
    precisao resb 2     ; reserva espaço pra precisão (0 ou 1 + ENTER)

section .text
    global _start

_start:
    ; programa principal

    ; imprime msg1
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

    ; imprime msg2
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

    ; imprime msg3
    push len_msg3
    push msg3
    call print
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