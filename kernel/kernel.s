.export kinit

kinit:
          JSR kernel
          JMP hang

kernel:
          RTS

hang:
          JMP hang
