AS = ca65
ASFLAGS = --cpu 65c02
CC = cc65
CFLAGS = -t none --cpu 65c02

files_o =         \
    crt0.o        \
    kernel/interrupt.o   \
    kernel/vectors.o     \
    kernel/wait.o        \
    kernel/kernel.o    \
    drivers/lcd.o      \
    
all: $(files_o)
	ld65 -C kernel/sbc.cfg $^ sbc.lib -o Ordinateur

crt0.o:
	cp lib/supervision.lib sbc.lib
	$(AS) kernel/crt0.s -o crt0.o
	ar65 a sbc.lib crt0.o

# Have every assembly *.s file be assembled by an implicit rule
%.o: kernel/%.s arch/%.s
	$(AS) $(ASFLAGS) $^ -o $@

.PHONY: clean
clean:
	rm -rf sbc.lib *.s *.o **/*.o Ordinateur

