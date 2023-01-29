.import   _stop
.export   _irq_int, _nmi_int

.import put_c
.import PORTA

.segment  "CODE"

.PC02

_nmi_int:
      	PHA
        
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
      	PLA

      	RTI

_irq_int:
      	RTI

break:
      	JMP _stop
