# Ordinateur
65C02 ROM Code for my petit project called *Ordinateur*

## Memory Map

| Base | Top | Name | Description |
|:-----|:----|:-----|-------------|
| 0x000 | 0x0FF  | `zp` | The Zero Page |
| 0x100 | 0x1FF  | `stack` | The Stack |
| 0x200 | 0x5FFF | `ram` | Random Access Memory |
| 0x6000 | - | `portb` | Port B of 65c22 |
| 0x6001 | - | `porta` | Port A of 65c22 |
| 0x6002 | - | `datab` | Data B of 65c22 |
| 0x6003 | - | `porta` | Data A of 65c22 |
| | | | |
| 0x600C | - | `pcr` | Peripheral Control Register of 65c22 |
| 0x600D | - | `ifr` | Interrupt Flag Register of 65c22 |
| 0x600E | - | `ier` | Interrupt Enable Register of 65c22 |
| | | | |
| 0xC000 | 0xFFFF | `rom` | Read Only Memory |
| | | | |
| 0xFFFA (l) | 0xFFFB (h) | `nmi` | Non-Maskable Interrupt |
| 0xFFFC (l) | 0xFFFD (h) | `rst` | Reset |
| 0xFFFE (l) | 0xFFFF (h) | `irq/brk` | Interrupt Request |
