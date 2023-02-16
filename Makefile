AS = ca65
ASFLAGS = --cpu 65c02 -I include
CC = cc65
CFLAGS = -g -t none --cpu 65c02 -I include

OBJDIR = build
SRCDIR = kernel

ASMSRC = $(wildcard $(SRCDIR)/asm/*.s)
ASMOBJ = $(patsubst $(SRCDIR)/asm/%.s,$(OBJDIR)/%.o,$(ASMSRC))

CSRC = $(wildcard $(SRCDIR)/*.c)
COBJ = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(CSRC))

all: Ordinateur

$(OBJDIR)/%.o: $(SRCDIR)/asm/%.s | $(OBJDIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJDIR)/%.s: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -o $@ $<

$(OBJDIR):
	mkdir $(OBJDIR)

Ordinateur: $(ASMOBJ) $(COBJ) sbc.lib
	ld65 -C sbc.cfg $^ sbc.lib -o $@

sbc.lib:
	cp kernel/supervision.lib sbc.lib

.PHONY: clean
clean:
	rm -rf $(OBJDIR) Ordinateur sbc.lib

