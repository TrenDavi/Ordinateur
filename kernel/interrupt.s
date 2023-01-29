.import   _stop
.export   _irq_int, _nmi_int

.import put_c
.import PORTA
.import lcd_instruction

.segment "DATA"

ps2c: .byte 0
ps2cp: .byte 0

.segment  "CODE"

.PC02

_nmi_int:
      	PHA

        INC ps2c
        INC ps2cp
        LDA ps2c
        
        CMP #1
        BEQ end
        CMP #10
        BEQ end
        CMP #11
        BEQ reset

        LDA ps2cp
        CMP #11
        BCC main
        JMP end
main:
        
        LDA PORTA
        AND #%00000001

        CMP #0
        BNE one
        LDA #'0'
        JSR put_c
        JMP end
one:
        LDA #'1'
        JSR put_c
end:
        LDA ps2cp
        CMP #33
        BEQ reset_c

      	PLA
      	RTI

reset:
        LDA #0
        STA ps2c
        JMP end

reset_c:
        LDA #0
        STA ps2cp
        JMP end
    
_irq_int:
      	RTI

break:
      	JMP _stop
