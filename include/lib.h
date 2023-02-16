#ifndef LIB_H
#define LIB_H

void put(unsigned char c);
void puts_len(unsigned char c[], unsigned int len);

void load_keyboard_handler(void (*func)(char));

#endif
