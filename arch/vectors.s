.import    init
.import    _nmi_int, _irq_int

.segment  "VECTORS"

.addr      _nmi_int    ; NMI interrupt vector $FFFA - $FFFB
.addr      init       ; Reset vector $FFFC - $FFFD
.addr      _irq_int    ; IRQ/BRK $FFFE - $FFFF
