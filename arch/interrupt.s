.import   _stop
.export   _irq_int, _nmi_int

.import put_c
.import SR
.import PORTB

.segment  "CODE"

.PC02

_nmi_int:  
          RTI

_irq_int:  
          PHA
          LDA SR
          JSR put_c
          LDA #' '
          JSR put_c

          PLA
          CLI
          RTI

break:     
          JMP _stop
