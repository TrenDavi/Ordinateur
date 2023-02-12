.export kinit
.export enter_handle
.export KEYBOARD_BUFFER

.import SCREEN_CHARS

.import put_c
.import lcd_instruction

KEYBOARD_BUFFER = $1000

enter_handle:
	RTS


kinit:
	JSR kernel
	JMP waitloop

kernel:
	; Clear the screen
	LDA #%000000001
	JSR lcd_instruction

	; Print a prompt character to the screen
	LDA #'>'
	JSR put_c

	RTS

waitloop:
	JMP waitloop
