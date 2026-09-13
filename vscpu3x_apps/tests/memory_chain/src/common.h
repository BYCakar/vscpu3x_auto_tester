/* VSCPU uses 32-bit words and word-addressed pointers. Parameters are generated. */
#define SHM_A0   (*(volatile unsigned int *)0x2000)
#define SHM_CM   (*(volatile unsigned int *)0x2001)
#define SHM_CT   (*(volatile unsigned int *)0x2002)
#define SHM_DONE (*(volatile unsigned int *)0x2003)

/* An odd multiplier preserves every input bit through subsequent iterations. */
unsigned int polynomial(unsigned int value)
{
    return value * 1664525u + 1013904223u;
}

unsigned int fill_memory(unsigned int state)
{
    volatile unsigned int *cursor = (volatile unsigned int *)ARRAY_BASE;

    do {
        *cursor = polynomial(state);
        *cursor = ~*cursor;
        state = ~*cursor;
        cursor++;
    } while (cursor < (volatile unsigned int *)CORE_WORDS);

    /* Publish the last stored (inverted) word, never the one-past-end word. */
    return *(cursor - 1);
}
