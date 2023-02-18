.export program_dino
.export dino_program_key_handle

.import put_c
.import lcd_instruction

.segment "CODE"

dino_program_key_handle:
	JSR put_c
	RTS

program_dino:
	LDA #%00000001
	JSR lcd_instruction
loop:
	JMP loop
	RTS
