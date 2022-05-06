.import   _stop ; Import knowledge of the _stop symbol, used to signal a
                ; software fault.
.export   _irq_int, _nmi_int  ; Allow the _irq_int and _nmi_int symbols to be
                              ; placed in the vector table (interrupt section).

.segment  "CODE" ; Force placement into the CODE memory section.

.PC02                             ; Force ca65 to use the 65C02 assembly mode

_nmi_int:  STA $8000  		  ; Read Keyboard Buf into A
  	   
	   LDA $8000		  ; Reset Keyboard Buf Counter
	   RTI                    ; Return

_irq_int:  RTI			  ; Not in use

; BRK detected, stop

break:     JMP _stop              ; If BRK is detected, something very bad
                                  ;   has happened, so stop running
