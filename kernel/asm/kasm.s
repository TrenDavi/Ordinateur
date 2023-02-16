.export kinit

.import lcd_instruction
.import _kernel

.segment "CODE"

kinit:
	; Clear the screen
	LDA #%000000001
	JSR lcd_instruction
	
	JSR _kernel

waitloop:
	JMP waitloop
