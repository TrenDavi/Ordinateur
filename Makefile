AS = ca65
ASFLAGS = --cpu 65c02
CC = cc65
CFLAGS = -t none --cpu 65c02

files_o =         		\
    crt0.o        		\
    kernel/via.o  		\
    kernel/vectors.o     	\
    kernel/wait.o        	\
    kernel/kernel.o    		\
    kernel/lcd.o      		\
    kernel/string.o      	\
    kernel/programs/list.o      \
    kernel/programs/dino.o      \
    kernel/programs/help.o      \
    
all: $(files_o)
	ld65 -C sbc.cfg $^ sbc.lib -o Ordinateur

crt0.o:
	cp kernel/supervision.lib sbc.lib
	$(AS) kernel/crt0.s -o crt0.o
	ar65 a sbc.lib crt0.o

# Have every assembly *.s file be assembled by an implicit rule
%.o: kernel/%.s kernel/program/%.s
	$(AS) $(ASFLAGS) $^ -o $@

.PHONY: clean
clean:
	rm -rf sbc.lib *.o kernel/programs/*.o kernel/*.o Ordinateur

