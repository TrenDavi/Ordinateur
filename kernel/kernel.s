.export kinit
.export key_handle
.export KEYBOARD_BUFFER

.import SCREEN_CHARS

.import put_c
.import lcd_instruction

.import back_and_space
.import string_cmp

.import SR

; The enter_handle and key_hand are two special handled that
; reroute data from the keyboard into the program that is currently
; running. This is a similar idea to application io in that the kernel
; sends keyboard io to the appropriate process. It will be the kernel's
; job to figure out how and where to send the data that will be stored
; in the A register when sent.

.segment "DATA"
; Supervisor state. When this variable is set to kernel, the kernel
; will be handling all functionality. When it is set to program, the
; program keyboard handler will be called instead. The program can then
; do what ever it wishes with that data from the keyboard. This is the only
; functionality passed to the program. The kernel will still handle interrupts
; such as getting data from the keyboard or IO messaging.
SUPERVISOR: .byte 0
; Address of the 0x100 long keyboard buffer. This buffer along with
; SCREEN_CHARS, which keeps a pointer on the last character put into the
; buffer, hold that data that has recently been entered.
KEYBOARD_BUFFER = $1000

.segment "CODE"

key_handle:
	TAX
	; Compare for kernel SuperVisior
	LDA SUPERVISOR
	CMP #0
	BEQ k_supervisor_key_handle

	RTS
k_supervisor_key_handle:
	TXA
	; Backspace
	CMP #%01100110
	BEQ k_supervisor_backspace_handle

	; Enter
	CMP #%01011010
	BEQ k_supervisor_enter_handle

	; Any other keypress
	LDX SCREEN_CHARS
	CPX #14
	BEQ exit_key_handle

        ; Increment the number of chars said to be on the screen and
        ; add it to the keyboard buffer
        LDX SCREEN_CHARS
        STA KEYBOARD_BUFFER, X
        INC SCREEN_CHARS


	JSR put_c
	JMP exit_key_handle

k_supervisor_backspace_handle:
	LDA SCREEN_CHARS
        CMP #0
        BEQ exit_key_handle

	; Since we're moving back
	DEC SCREEN_CHARS
	
	LDA #0
	LDX SCREEN_CHARS
	STA KEYBOARD_BUFFER, X

	JSR back_and_space
	JMP exit_key_handle

k_supervisor_enter_handle:
	; Compare the keyboard buffer with all the programs
	; and commands the computer has. The result will be stored
	; in A
	LDA #>KEYBOARD_BUFFER
	STA $01
	LDA #<KEYBOARD_BUFFER
	STA $00

	; load the address of list and its length, then compare
	LDA #>list
	STA $03
	LDA #<list
	STA $02
	LDA #4 ; Length of 'list'
	STA $04
	JSR string_cmp

	CMP #0
	BNE no
	LDA #%11111111
	STA SR
no:

	JMP exit_key_handle

exit_key_handle:
	RTS

kinit:
	; Set the SuperVisor state to kernel since we're going into kernel
	; terminal mode for the user to input a command, first.
	LDA #0
	STA SUPERVISOR

	; Jump to the kernel
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

.segment "RODATA"
; command 1
list: .asciiz "list"
