#include "lib.h"

void put(unsigned char c) {
	// Add the character to the screen
	asm("jsr put_c");
}

void puts_len(unsigned char c[], unsigned int len) {
	int x = 0;
	for (x = 0; x < len; x++) {
		asm("jsr put_c");
	}
}

void load_keyboard_handler(void (*func)(unsigned char)) {
	// Agruments are used in asm. This is to ignore the unused warning
	func = func;

        // Keyboard interrupt with code as unsigned char at ZP location 0x30
        asm("sta $30");
        asm("stx $31");
}
