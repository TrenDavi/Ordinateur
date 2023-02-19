.import init
.import lcd_instruction
.import put_c
.import prints
.import wait

.import SR

.import list
.import dino
.import help

.export program_list
.export list_program_key_handle

.segment "CODE"

list_program_key_handle:
	RTS

program_list:
	LDA #%00000001
	JSR lcd_instruction
	
	LDA #'1'
	JSR put_c
	LDA #'.'
	JSR put_c
	LDA #' '
	JSR put_c

        LDA #>dino
        STA $01
        LDA #<dino
        STA $00
        LDA #4
        JSR prints
	
	LDA #%00000011
	JSR wait

	LDA #%00000001
	JSR lcd_instruction

	LDA #'2'
	JSR put_c
	LDA #'.'
	JSR put_c
	LDA #' '
	JSR put_c

        LDA #>list
        STA $01
        LDA #<list
        STA $00
        LDA #4
        JSR prints

	LDA #%00000011
	JSR wait

	LDA #%00000001
	JSR lcd_instruction

	LDA #'3'
	JSR put_c
	LDA #'.'
	JSR put_c
	LDA #' '
	JSR put_c

        LDA #>help
        STA $01
        LDA #<help
        STA $00
        LDA #4
        JSR prints

	LDA #%00000011
	JSR wait

	; reset once finished
	RTS
