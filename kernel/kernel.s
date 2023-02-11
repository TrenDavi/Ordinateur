.export kinit

.import put_c

kinit:
	JSR kernel
	JMP waitloop

kernel:
	; Print a prompt character to the screen
	LDA #'>'
	JSR put_c

	RTS

waitloop:
	JMP waitloop
