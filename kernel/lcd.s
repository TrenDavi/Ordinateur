.export back_and_space
.export lcd_wait
.export lcd_busy
.export lcd_instruction

.export put_c
.export back_and_space

.import SCREEN_CHARS

.import PORTB
.import PORTA
.import DDRB
.import DDRA

.import SR
.import ACR
.import PCR
.import IFR
.import IER

.export E
.export RW
.export RS

.segment "DATA"

E  = %10000000
RW = %01000000
RS = %00100000

.segment "CODE"

lcd_wait:
        PHA
        LDA #%00000000  ; Port B is input
        STA DDRB

lcd_busy:
        LDA #RW
        STA PORTA
        LDA #(RW | E)
        STA PORTA
        LDA PORTB
        AND #%10000000
        BNE lcd_busy
        LDA #RW
        STA PORTA
        LDA #%11111111  ; Port B is output
        STA DDRB
        PLA

        RTS

lcd_instruction:
        JSR lcd_wait
        STA PORTB
        LDA #0         ; Clear RS/RW/E bits
        STA PORTA
        LDA #E         ; Set E bit to send instruction
        STA PORTA
        LDA #0         ; Clear RS/RW/E bits
        STA PORTA

        RTS

put_c:
        JSR lcd_wait
        STA PORTB
        LDA #RS         ; Set RS; Clear RW/E bits
        STA PORTA
        LDA #(RS | E)   ; Set E bit to send instruction
        STA PORTA
        LDA #RS         ; Clear E bits
	STA PORTA

	RTS

back_and_space:
	PHA
	LDA #%00010000
	JSR lcd_instruction

	LDA #%00000100
	JSR lcd_instruction

	LDA #' '
	JSR put_c

	LDA #%00010100
	JSR lcd_instruction

	LDA #%00000110
	JSR lcd_instruction
	PLA
	RTS
