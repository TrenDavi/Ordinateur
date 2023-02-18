.import init
.import lcd_instruction
.import put_c
.import wait
.import SR

.export program_list
.export list_program_key_handle

.segment "CODE"

list_program_key_handle:
	RTS

program_list:
	LDA #%00000001
	JSR lcd_instruction
	
	LDA #%00000111
	JSR wait

	LDA #%11111111
	STA SR

	; wait for one second
	LDA #%00000011
	JSR wait

	; reset once finished
	RTS
