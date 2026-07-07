section .data
    msg_mod1 db 'Digite o dividendo: ', 0
    len_mod1 equ $ - msg_mod1

    msg_mod2 db 'Digite o divisor: ', 0
    len_mod2 equ $ - msg_mod2

    msg_res db 'Resto da divisao (MOD): ', 0
    len_res equ $ - msg_res

section .text
    global modulo

    extern print
    extern print16
    extern print32
    extern input16
    extern input32

modulo: