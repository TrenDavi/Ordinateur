.import   _stop
.export   _irq_int, _nmi_int

.segment  "CODE"

.PC02

_nmi_int:  RTI

_irq_int:  RTI

break:     JMP _stop
