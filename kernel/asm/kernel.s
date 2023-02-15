.export kinit
.export key_handle

.import lcd_instruction

.import SR

.segment "CODE"

key_handle:
	RTS

kinit:
	JSR kernel
	JMP waitloop

kernel:
	; Clear the screen
	LDA #%000000001
	JSR lcd_instruction

	RTS

waitloop:
	JMP waitloop
