.export   init, exit

.export   __STARTUP__ : absolute = 1

.import   __RAM_START__, __RAM_SIZE__

.import    copydata, zerobss, initlib, donelib

.import PORTB
.import PORTA
.import DDRB
.import DDRA

.import PCR
.import IFR
.import IER
 
.import E
.import RW
.import RS

.import lcd_instruction

.import   kinit

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

          JSR kinit


loop:
        jmp loop
exit:    
          JSR donelib ; Run destructors
          BRK
