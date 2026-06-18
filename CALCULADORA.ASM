section .data
    ; Mensagens globais do sistema
    msg1 db 'Bem-vindo. Digite seu nome: ', 0
    len_msg1 equ $ - msg1

section .bss
    ; variaveis globais

section .text
    global _start

_start:
    ; programa principal
    push len_msg1   ; empilha tamanho da string
    push msg1       ; empilha o ponteiro da string
    call print      ; chama função
    add esp, 8      ; limpa pilha

    ; fim do programa
    mov eax, 1      ; syscall de exit
    mov ebx, 0      ; codigo de retorno
    int 0x80

print:
    push ebp        ; salva o base pointer atual
    mov ebp, esp    ; atualiza

    mov eax, 4          ; syscall pra write
    mov ebx, 1          ; saída
    mov ecx, [ebp + 8]  ; ponteiro string
    mov edx, [ebp + 12] ; tamanho string
    int 0x80            ; chamada kernel

    pop ebp     ; restaura o base pointer
    ret         ; retorna