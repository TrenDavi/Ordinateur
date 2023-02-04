.export lcd_wait
.export lcd_busy
.export lcd_instruction

.export put_c

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

E  = %10000000
RW = %01000000
RS = %00100000

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
