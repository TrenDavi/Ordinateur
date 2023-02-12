.import _stop
.import init
.import back_and_space
.import key_handle

.import KEYBOARD_BUFFER
.export SCREEN_CHARS

.export _irq_int, _nmi_int

.export PORTB
.export PORTA
.export DDRB
.export DDRA

.export SR
.export ACR
.export PCR
.export IFR
.export IER

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

SR  = $600A
ACR = $600B
PCR = $600C
IFR = $600D
IER = $600E

.import put_c
.import lcd_instruction


.segment  "CODE"

.PC02

_irq_int:
      	RTI

break:
      	JMP _stop

; PS/2 Driver

; Given PS2 keycodes shift in backwards and in order to
; save some computation, all codes are fliped MSB to LSB
; accordingly, 10011010 = 01011001
;
; Load one bit in at a time. Once eight have been shifted in,
; check if it's a release code or a character code.
; If it is a release code: wait for the next code. If it isn't,
; print the character to the screen

.segment "DATA"

; Counter where we are in the input
SHIFT_COUNTER: .byte 0
; Storage for the bits being shifted in
DATA: .byte 0
; If true, the last byte was a release code
RELEASE_FLAG: .byte 0
; Counts how many chars have been printed
SCREEN_CHARS: .byte 0
; Keep track if the shift key has been shifted
SHIFT_SET: .byte 0

.segment "CODE"

_nmi_int:
      	PHA
        PHX

        ; Read in the data from bit 0 of PORTA on the 65C22 VIA
        ; load it to NEW_BIT
        LDA PORTA
        AND #%00000001
        TAX

        ; The data bits are from SHIFT_COUNTER 1-9. 0 is the start bit,
        ; 10 is parity, and 11 is the final stop bit. We will be ignoring
        ; any other bit rather than data 1-8 bits
        LDA SHIFT_COUNTER
        CMP #0
        BEQ skip_input
        CMP #9
        BEQ skip_input
        CMP #10
        BEQ read

        ; Load DATA into A, Shift it Left one, then OR it with the NEW_BIT
        ; Lastly, store it back to the data holder
        LDA DATA
        ASL
        CPX #1
        BNE no_or
        ORA #1 
no_or:
        STA DATA
skip_input:

        ; Increments the shift counter then RTIs
        JMP inc_exit

read:
        ; Check if it's a release code or a character code. If it's a
        ; release code, set the release next flag that indicated the next
        ; code shows which key has been released.

        ; Since all bits have now been shifted in, reset the shift counter
        LDA #0
        STA SHIFT_COUNTER

        ; First check if the release flag has been set. This would mean the
        ; last code to be read in was a 0xF0 byte signifing a release code
        ; coming next
        LDA RELEASE_FLAG
        CMP #1
        BEQ read_release

        ; Check if the code is a special code / function outside of printing
        ; a character to the screen. This includes checking if the code is a
        ; release code or the escape key.

        ; Load the final 8 bit code
        LDA DATA
        
        ; Compare for release code. If so: set the release code flag
        CMP #%00001111 ; 0xF0 as 0x0F
        BEQ release

        ; Compare for escape. If so: reset the processor
        CMP #%01101110
	BEQ reset_cpu

	; Compare for shift. If so: set the shift flag to 1
        CMP #%01001000
        BEQ set_shift

keypress:
	; Put the indexed code to the screen
        LDX DATA
	
	LDA SHIFT_SET
	CMP #0
        BEQ print_without_shift
	JMP print_with_shift

print_without_shift:
        LDA keymap_lower, X
	JMP print_key
print_with_shift:
        LDA keymap_upper, X
	JMP print_key
	
print_key:
	; Increment the number of chars said to be on the screen and
	; add it to the keyboard buffer
	LDX SCREEN_CHARS
	STA KEYBOARD_BUFFER, X
	INC SCREEN_CHARS

	; Trigger the kernel's keypress handler
	JSR key_handle_j

        JMP exit_nmi

release:
        ; Set the release flag, indicating that the next byte to be read in
        ; is a release code
        LDA #1
        STA RELEASE_FLAG
        JMP exit_nmi
                
read_release:
        ; Reset the release flag
        LDA #0
        STA RELEASE_FLAG

        ; Load the code into A
        LDA DATA

	; Put the scan code onto the LED shift register display
        STA SR

	; Compare for shift. If so: set the shift flag to 0
        CMP #%01001000
        BEQ remove_shift

        JMP exit_nmi
        
inc_exit:
        ; Since a new bit is being shifted in, increment the counter
        INC SHIFT_COUNTER
        JMP exit_nmi

exit_nmi:
	PLA
        PLX
        RTI

reset_cpu:
	JMP init

set_shift:
	LDA #1
        STA SHIFT_SET
	JMP exit_nmi

remove_shift:
	LDA #0
        STA SHIFT_SET
	JMP exit_nmi

key_handle_j:
	JSR key_handle
	RTS


.segment "RODATA"

; Keymap, no shift
keymap_lower:
  .byte "x??????????????"
  .byte "???????????????"
  .byte "????o?e?????[?g"
  .byte "?????;?t??Xa???"
  .byte "u?????k?x?????'"
  .byte "?b?????/?v???z?"
  .byte "??m?????9?3???1"
  .byte "???6???????5???"
  .byte "2???8?????,?c??"
  .byte "?????n?????.? ?"
  .byte "????????????0?4"
  .byte "???q???y?????p?"
  .byte "r???w???7?????i"
  .byte "?d???????h?????"
  .byte "l?f???s?]?j????"
  .byte "123456789ABCDEF"

; Keymap, shift
keymap_upper:
  .byte "x??????????????"
  .byte "???????????????"
  .byte "????O?E?????{?G"
  .byte "?????:?T??XA???"
  .byte "U?????K?X?????"
  .byte '"'
  .byte "?B???????V???Z?"
  .byte "??M?????(?#???!"
  .byte "???^???????%???"
  .byte "@???*?????<?C??"
  .byte "?????N?????>? ?"
  .byte "????????????)?$"
  .byte "???Q???Y?????P?"
  .byte "R???W???&?????I"
  .byte "?D???????H?????"
  .byte "L?F???S?}?J????"
  .byte "123456789ABCDEF"

; End of PS/2 driver
