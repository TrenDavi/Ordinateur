.export kinit
.export key_handle

.import lcd_instruction

.import _kernel


.segment "CODE"

key_handle:
	RTS

kinit:
	; Clear the screen
	LDA #%000000001
	JSR lcd_instruction
	
	JSR _kernel

waitloop:
	JMP waitloop
