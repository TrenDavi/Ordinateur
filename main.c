int printk();

int printscr(char* str);

// Prints out a given string of 16 or less characters
// to the top portion of the LCD screen.
int printscr(char* str) {
    int len;
    for(len = 0; str[len] != 0; len = len + 1) {
        if (len > 16)
            return 1;
    }
    return 0;
}

int main() {
    while(1) {}
    return 0;
}
