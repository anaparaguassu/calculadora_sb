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
    