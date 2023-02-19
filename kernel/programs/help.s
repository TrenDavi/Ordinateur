.export program_help

.import program_list

.import wait
.import prints

.import lcd_instruction

.segment "CODE"

program_help:
        LDA #%00000001
        JSR lcd_instruction

        LDA #>help1
        STA $01
        LDA #<help1
        STA $00
        LDA #16
        JSR prints

        LDA #%00000011
	JSR wait

	JSR program_list
	RTS

.segment "RODATA"
help1: .asciiz "Enter a command:"
