# Ordinateur
65C02 ROM Code for my petit project *Ordinateur*

## For the Travelers
Interesting files you may want to see...
- kernel/via.s: This is my implementation for a PS/2 keyboard driver along with other 65C22 functionality. The keyboard clock is directly hooked up to the Non-maskable interrupt (nmi) pin on the 65C02, and the data pin is connected to bit 0 on PORTA of the 65C22. The 65C02 reads in one bit at a time.
- kernel/lcd.s Modified version of Ben Eater's LCD code.


## Memory Map

| Base | Top | Name | Description |
|:-----|:----|:-----|-------------|
| 0x000 | 0x0FF  | `zp` | Zero Page |
| 0x100 | 0x1FF  | `stack` | Stack |
| 0x200 | 0x5FFF | `ram` | Random Access Memory |
| 0x6000 | 0x600F | `via` | Base address of 65c22 |
| | | | |
| 0xC000 | 0xFFFF | `rom` | Read Only Memory |
| | | | |
| 0xFFFA (l) | 0xFFFB (h) | `nmi` | Non-Maskable Interrupt |
| 0xFFFC (l) | 0xFFFD (h) | `rst` | Reset |
| 0xFFFE (l) | 0xFFFF (h) | `irq/brk` | Interrupt Request |
