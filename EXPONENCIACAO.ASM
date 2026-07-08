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