PORTB = $8000
PORTA = $8001
DDRB = $8002
DDRA = $8003

PCR = $600C
IFR = $600D
IER = $600E

E  = %10000000
RW = %01000000
RS = %00100000

.export   init, exit

.export   __STARTUP__ : absolute = 1

.import   __RAM_START__, __RAM_SIZE__

.import    copydata, zerobss, initlib, donelib

.include  "zeropage.inc"


.segment  "STARTUP"

init:    
          LDX     #$FF
          TXS
          CLD

; Set stack pointer
          LDA     #<(__RAM_START__ + __RAM_SIZE__)
          STA     sp
          LDA     #>(__RAM_START__ + __RAM_SIZE__)
          STA     sp+1

; Initialize memory storage
          JSR     zerobss              ; Clear BSS segment
          JSR     copydata             ; Initialize DATA segment
          JSR     initlib              ; Run constructors

; Initialize screen
          LDA #%11111111
          STA DDRB
          LDA #%11100000
          STA DDRA
  

          ; Enable 8-bit mode, 2-line display, 5x8 font
          LDA #%00111000
          JSR lcd_instruction

          ; Turn display on, cursor on, blink off
          LDA #%00001111
          JSR lcd_instruction

          ; Increment and shift cursor, don't shift display
          LDA #%00000110
          JSR lcd_instruction

          ; Clear display
          LDA #$00000001
          JSR lcd_instruction

; Initialize interrups
          LDA #%00000001
          STA PCR
          LDA #%10000010
          STA IER
          CLI

exit:    
          JSR     donelib ; Run destructors
          BRK


lcd_wait:
          PHA
          LDA #%00000000  ; Port B is input
          STA DDRB

lcdbusy:
          LDA #RW
          STA PORTA
          LDA #(RW | E)
          STA PORTA
          LDA PORTB
          AND #%10000000
          BNE lcdbusy
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
