.export kinit
.export enter_handle

.import put_c

enter_handle:
	LDA #'h'
	JSR put_c
	RTS

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
