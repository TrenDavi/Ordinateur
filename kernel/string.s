.export string_cmp
.export prints

.import put_c

.segment "CODE"

string_cmp:
	PHY
        LDY #0
compare_loop:
        LDA ($00), Y
        CMP ($02), Y
        BNE exit_compare_with_fail
        CPY $04
        BEQ exit_compare_with_success
        INY
        JMP compare_loop

exit_compare_with_success:
        LDA #0
	PLY
        RTS

exit_compare_with_fail:
        LDA #1
	PLY
        RTS

.segment "DATA"
TEMP_LEN: .byte 0

.segment "CODE"

prints:
	PHY

	STA TEMP_LEN
	LDY #0
ploop:
        LDA ($00), Y
	CPY TEMP_LEN
	BEQ pexit
	JSR put_c
	INY
	JMP ploop
pexit:
	PLY
	RTS
