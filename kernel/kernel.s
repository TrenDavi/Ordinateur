.export kinit
.export key_handle
.export KEYBOARD_BUFFER
.export COMMAND_BUFFER
.export HISTORY_COUNTER

.export list
.export dino
.export help

.import list_program_key_handle
.import dino_program_key_handle

.import init

.import T1CH
.import T1LL
.import T1LH
.import SR
.export wait

.import SCREEN_CHARS

.import put_c
.import lcd_instruction

.import back_and_space
.import string_cmp
.import prints

.import program_list
.import program_dino
.import program_help

.segment "DATA"

EXTENDED1: .byte 0
END_VAL: .byte 0

.segment "CODE"

wait:
	PHX
	PHY

	STA END_VAL
	LDA #0
	STA EXTENDED1
	LDY #0
wait_loop:
	LDX #0
time_l:
	INX
	CPX #255
	BNE time_l
	INY
	CPY #5
	BNE wait_loop
	INC EXTENDED1
	LDA EXTENDED1
	CMP END_VAL
	BEQ end_wait
	JMP wait_loop
	

end_wait:
	PLY
	PLX
	RTS


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
HISTORY_COUNTER: .byte 0
; Address of the 0x100 long keyboard buffer. This buffer along with
; SCREEN_CHARS, which keeps a pointer on the last character put into the
; buffer, hold that data that has recently been entered.
KEYBOARD_BUFFER = $1000 ; 0xFF
COMMAND_BUFFER = $1100  ; 0x08

.segment "CODE"

key_handle:
	; Compare for kernel SuperVisior
	LDX SUPERVISOR
	CPX #0
	BEQ k_supervisor_key_handle
	CPX #1
	BEQ list_program_handle_j
	CPX #2
	BEQ dino_program_handle_j

return_to_key_handle:
	JMP exit_key_handle

exit_key_handle:
	RTS

list_program_handle_j:
	JSR list_program_key_handle
	JMP return_to_key_handle

dino_program_handle_j:
	JSR dino_program_key_handle
	JMP return_to_key_handle

k_supervisor_down_handle:
	LDA HISTORY_COUNTER
	CMP #0
	BEQ exit_key_handle

	JMP exit_key_handle1

k_supervisor_key_handle:
	STA SR
	; Backspace
	CMP #%01100110
	BEQ k_supervisor_backspace_handle

	; Enter
	CMP #%01011010
	BEQ k_supervisor_enter_handle

	; Up
	CMP #%10101110
	BEQ k_supervisor_up_handle

	; Down
	CMP #%01001110
	BEQ k_supervisor_down_handle

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
	LDA SCREEN_CHARS
	CMP #0
	BEQ exit_key_handle

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
	BNE next
	LDA #1
	STA SUPERVISOR
	JMP exit_key_handle

k_supervisor_up_handle:
	LDA HISTORY_COUNTER
	CMP #8
	BEQ exit_key_handle1

        LDX #0
clear_loop1:
        STA KEYBOARD_BUFFER, X
        CPX #255
        BEQ exit_clear_loop1
        INX
        JMP clear_loop1
exit_clear_loop1:
	LDA #%00000001
	JSR lcd_instruction

	LDX HISTORY_COUNTER
	LDA COMMAND_BUFFER, X
	CMP #0
	BEQ exit_key_handle1
	INX
	STX HISTORY_COUNTER

	CMP #1
	BNE next_command
        LDA #>list
        STA $01
        LDA #<list
        STA $00
        LDA #4
        JSR prints

	LDA #5
	STA SCREEN_CHARS

	JMP exit_key_handle
next_command:
	CMP #2
	BNE next_command1
        LDA #>dino
        STA $01
        LDA #<dino
        STA $00
        LDA #4
        JSR prints

	LDA #5
	STA SCREEN_CHARS

	JMP exit_key_handle
next_command1:
	CMP #3
	BNE next_command2
        LDA #>help
        STA $01
        LDA #<help
        STA $00
        LDA #4
        JSR prints
	
	LDA #5
	STA SCREEN_CHARS

	JMP exit_key_handle
next_command2:
	
	

	JMP exit_key_handle1

exit_key_handle1:
	RTS


next:

	; load the address of dino and its length, then compare
	LDA #>dino
	STA $03
	LDA #<dino
	STA $02
	LDA #4 ; Length of 'dino'
	STA $04
	JSR string_cmp

	CMP #0
	BNE next1
	LDA #2
	STA SUPERVISOR
	JMP exit_key_handle

next1:

	; load the address of help and its length, then compare
	LDA #>help
	STA $03
	LDA #<help
	STA $02
	LDA #4 ; Length of 'help'
	STA $04
	JSR string_cmp

	CMP #0
	BNE next2
	LDA #3
	STA SUPERVISOR
	JMP exit_key_handle

next2:

not_found:
	LDA #%00000001
	JSR lcd_instruction

	LDA #>not_found1
	STA $01
	LDA #<not_found1
	STA $00
	LDA #7
	JSR prints

	LDA #%11000000
	JSR lcd_instruction

	LDA #>KEYBOARD_BUFFER
	STA $01
	LDA #<KEYBOARD_BUFFER
	STA $00
	LDA SCREEN_CHARS
	JSR prints

	LDA #%00000100
	JSR wait
	
	LDA #%00000001
	JSR lcd_instruction

	LDA #>not_found2
	STA $01
	LDA #<not_found2
	STA $00
	LDA #9
	JSR prints

	LDA #%00000100
	JSR wait
	
	LDA #%00000001
	JSR lcd_instruction

	LDA #>not_found3
	STA $01
	LDA #<not_found3
	STA $00
	LDA #10
	JSR prints

	LDA #%00000011
	JSR wait
	
	JMP init

kinit:
	CLI

	; Set the SuperVisor state to kernel since we're going into kernel
	; terminal mode for the user to input a command, first.
kernel:
	LDA #%00000001
	JSR lcd_instruction
	LDA #0
	STA SUPERVISOR
	STA SR

	; Print a prompt character to the screen
	LDA #'>'
	JSR put_c

waitloop:
	LDA SUPERVISOR
	CMP #0
	BEQ waitloop
	CMP #1
	BEQ list_program_run
	CMP #2
	BEQ dino_program_run
	CMP #3
	BEQ help_program_run
	JMP waitloop

store_program_history:
	LDX #6
store_loop:
	LDA COMMAND_BUFFER, X
	INX
	STA COMMAND_BUFFER, X
	DEX
	DEX
	CPX #0
	BNE store_loop
	LDA SUPERVISOR
	STA COMMAND_BUFFER
	RTS

list_program_run:
	JSR store_program_history
	JSR program_list
	LDA #0
	STA SUPERVISOR
	JMP init

dino_program_run:
	JSR program_dino
	JSR store_program_history
	LDA #0
	STA SUPERVISOR
	JMP init

help_program_run:
	JSR program_help
	JSR store_program_history
	LDA #0
	STA SUPERVISOR
	JMP init

.segment "RODATA"
; command 1
list: .asciiz "list"
; command 2
dino: .asciiz "dino"
; command 3
help: .asciiz "help"

; error message
not_found1: .asciiz "Command"
not_found2: .asciiz "Not found"
not_found3: .asciiz "Use 'help'"
