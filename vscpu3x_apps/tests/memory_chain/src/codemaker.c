#include "generated/memory_chain_cm_params.h"
#include "common.h"

#define UART_RX_EMPTY (*(volatile unsigned int *)0x2100)
#define UART_RX_READ  (*(volatile unsigned int *)0x2101)
#define UART_RX_DATA  (*(volatile unsigned int *)0x2102)
#define UART_TX_DATA  (*(volatile unsigned int *)0x2103)
#define UART_TX_COUNT (*(volatile unsigned int *)0x2104)

void uart_putc(unsigned int character)
{
    while (UART_TX_COUNT != 0) {
    }
    UART_TX_DATA = character;
    UART_TX_COUNT = 1;
}

int main(void)
{
    char *prefix = "Hello ";
    unsigned int character;

    while (*prefix != 0) {
        uart_putc(*prefix);
        prefix++;
    }
    do {
        while (UART_RX_EMPTY != 0) {
        }
        character = UART_RX_DATA;
        UART_RX_READ = 1;
        while (UART_RX_READ != 0) {
        }
        if (character != 0) {
            uart_putc(character);
        }
    } while (character != 0);
    while (UART_TX_COUNT != 0) {
    }

    while ((SHM_DONE & 1u) == 0) {
    }
    SHM_CM = fill_memory(SHM_A0);
    SHM_DONE = SHM_DONE | 2u;
    return 0;
}
