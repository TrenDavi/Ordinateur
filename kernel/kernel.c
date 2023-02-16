void load_keyboard_handler(void (*func)(unsigned char)) {
	// Keyboard interrupt with sent code as unsigned char at ZP 0x30
	asm("sta $30");
	asm("stx $31");
}

void kernel_key_handler(unsigned char c) {
	asm("JSR put_c");
	asm("JSR incsp1");
	asm("JMP key_ret");
}

int kernel() {
	// Load keyboard interrupt handler for the kernel.
	// This will enable the computer to first boot into
	// the prompt program
	load_keyboard_handler(*kernel_key_handler);

	return 0;
}
