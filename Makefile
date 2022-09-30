AS = ca65
ASFLAGS = --cpu 65c02
CC = cc65
CFLAGS = -t none --cpu 65c02

files_o =         \
    main.o        \
    crt0.o        \
    interrupt.o   \
    vectors.o     \
    wait.o
    
all: $(files_o)
	ld65 -C arch/sbc.cfg -m main.map $^ sbc.lib -o Ordinateur

crt0.o:
	cp lib/supervision.lib sbc.lib
	$(AS) arch/crt0.s -o crt0.o
	ar65 a sbc.lib crt0.o

# Have every C *.c file be compiled and assembled by an implicit rule
%.o: %.c
	$(CC) $(CFLAGS) $^ -o $^.s
	$(AS) $(ASFLAGS) $^.s -o $@

# Have every assembly *.s file be assembled by an implicit rule
%.o: arch/%.s
	$(AS) $(ASFLAGS) $^ -o $@

.PHONY: clean
clean:
	rm -rf **/*.o **/*.map

.PHONY: cleanall
cleanall:
	rm -rf **/*.o **/*.map Ordinateur
