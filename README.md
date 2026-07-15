# Calculadora IA-32
Calculadora interativa desenvolvida em linguagem Assembly IA-32 com estrutura modular, onde a interface principal e cada operação matemática estão organizadas em arquivos independentes.

---

**Autora:**
Ana Luísa de Souza Paraguassu - 231003442

**Ambiente de Desenvolvimento:**
- Sistema Operacional: WSL (Windows Subsystem for Linux).
- Interface com o SO: Chamadas de sistema (syscalls) nativas do kernel Linux via interrupção `0x80`.
- Montador: NASM (Netwide Assembler) configurado para formato de saída `elf32`.
- Ligador: LD (GNU Linker) configurado para emulação de arquitetura `elf_i386`.

---

## Compilação

### Opção 1: Via Makefile
- Compilar tudo: 
```bash
  make
```
- Executar o programa:
```bash
  ./calculadora
```
- Limpar arquivos temporários: 
```bash
  make clean
```

### Opção 2: Manualmente
- Montagem dos arquivos objeto (.o):
```bash
  nasm -f elf32 CALCULADORA.ASM -o CALCULADORA.o
  nasm -f elf32 SOMA.ASM -o SOMA.o
  nasm -f elf32 SUBTRACAO.ASM -o SUBTRACAO.o
  nasm -f elf32 MULTIPLICACAO.ASM -o MULTIPLICACAO.o
  nasm -f elf32 DIVISAO.ASM -o DIVISAO.o
  nasm -f elf32 MOD.ASM -o MOD.o
  nasm -f elf32 EXPONENCIACAO.ASM -o EXPONENCIACAO.o
```
- Ligação de todos os objetos no executável final:
```bash
  ld -m elf_i386 CALCULADORA.o SOMA.o SUBTRACAO.o MULTIPLICACAO.o DIVISAO.o MOD.o EXPONENCIACAO.o -o calculadora
```
- Execução do binário:
```bash
    ./calculadora
```

---

## Funcionalidades Implementadas
- **Operações matemáticas:** Suporte a soma, subtração, multiplicação, divisão, resto da divisão (MOD) e exponenciação.
- **Precisão configurável:** Permite o uso de 16 bits ou 32 bits.
- **Tratamento de Overflow:** Monitoramento de estouro nas operações de multiplicação e exponenciação para evitar corrupção de memória.
- **Menu de execução contínua:** loop interativo que permite realizar novos cálculos sequencialmente sem fechar o terminal.