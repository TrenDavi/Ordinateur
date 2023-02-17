.import init
.export program_list

.segment "CODE"

program_list:

	; reset once finished
	JMP init
