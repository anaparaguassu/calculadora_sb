# Nome do executável final
TARGET = calculadora

# Compiladores e flags
ASM = nasm
ASMFLAGS = -f elf32
LD = ld
LDFLAGS = -m elf_i386

# Lista de todos os arquivos objeto que precisamos gerar
OBJS = CALCULADORA.o SOMA.o SUBTRACAO.o MULTIPLICACAO.o DIVISAO.o MOD.o

# Regra principal: o que acontece quando você digita apenas 'make'
all: $(TARGET)

# Como gerar o executável final juntando tudo
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(TARGET)

# Como compilar qualquer arquivo .ASM para .o
%.o: %.ASM
	$(ASM) $(ASMFLAGS) $< -o $@

# Regra para limpar os arquivos gerados (make clean)
clean:
	rm -f *.o $(TARGET)