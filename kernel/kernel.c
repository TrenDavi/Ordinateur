#include "lib.h"

#define KEYBOARD_BUFFER_SIZE 64
#define SCREEN_BUFFER_SIZE 32

unsigned char key_buffer[KEYBOARD_BUFFER_SIZE];
unsigned char screen_buffer[SCREEN_BUFFER_SIZE];

void kernel_key_handler(unsigned char c) {
	// Exit from handler by JMP rather than RTS
	asm("jsr incsp1"); // Pop stack
	asm("jmp key_ret"); // Jmp
}

unsigned char f[] = "hello";
int i = 0;
int kernel() {
	// Load keyboard interrupt handler for the kernel.
	// This will enable the computer to first boot into
	// the prompt program
	load_keyboard_handler(*kernel_key_handler);

	// Initialize the keyboard buffer
	for(i = 0; i < KEYBOARD_BUFFER_SIZE; i++) {
		key_buffer[i] = 0x0;
	}

	// Initialize the screen buffer
	for(i = 0; i < SCREEN_BUFFER_SIZE; i++) {
		screen_buffer[i] = 0x0;
	}

	puts_len(f, 5);

	return 0;
}
