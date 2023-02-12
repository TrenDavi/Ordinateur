.export string_cmp

.segment "CODE"

string_cmp:
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
        RTS

exit_compare_with_fail:
        LDA #1
        RTS
