.export kinit
.export key_handle
.export KEYBOARD_BUFFER

.import SCREEN_CHARS

.import put_c
.import lcd_instruction

; The enter_handle and key_hand are two special handled that
; reroute data from the keyboard into the program that is currently
; running. This is a similar idea to application io in that the kernel
; sends keyboard io to the appropriate process. It will be the kernel's
; job to figure out how and where to send the data that will be stored
; in the A register when sent.

.segment "DATA"

KEYBOARD_BUFFER = $1000

.segment "CODE"

key_handle:
	JSR put_c
	RTS

kinit:
	JSR kernel
	JMP waitloop

kernel:
	; Clear the screen
	LDA #%000000001
	JSR lcd_instruction

	; Print a prompt character to the screen
	LDA #'>'
	JSR put_c

	RTS

waitloop:
	JMP waitloop
