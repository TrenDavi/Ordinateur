.export  _wait, _stop

.segment  "CODE"

.proc _wait: near

           CLI
.byte      $CB
           RTS

.endproc

.proc _stop: near

.byte      $DB

.endproc
