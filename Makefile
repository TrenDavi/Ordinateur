AS = ca65
ASFLAGS = --cpu 65c02
CC = cc65
CFLAGS = -t none --cpu 65c02

all: crt0.o main.o interrupt.o vectors.o wait.o
	ld65 -C arch/sbc.cfg -m build/main.map build/interrupt.o build/vectors.o \
				build/wait.o build/main.o build/sbc.lib -o build/6502

crt0.o:
	mkdir -p build
	cp lib/supervision.lib build/sbc.lib
	$(AS) arch/crt0.s -o build/crt0.o
	ar65 a build/sbc.lib build/crt0.o

# Have every C *.c file be compiled and assembled by an implicit rule
%.o: %.c
	$(CC) $(CFLAGS) $^ -o build/$^.s
	$(AS) $(ASFLAGS) build/$^.s -o build/$@

# Have every assembly *.s file be assembled by an implicit rule
%.o: arch/%.s
	$(AS) $(ASFLAGS) $^ -o build/$@

.PHONY: clean
clean:
	rm -rf build
