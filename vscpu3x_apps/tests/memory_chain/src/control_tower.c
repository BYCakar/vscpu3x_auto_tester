#include "generated/memory_chain_ct_params.h"
#include "common.h"

#define GPIO_OUTPUT (*(volatile unsigned int *)0x203E)
#define GPIO_INPUT  (*(volatile unsigned int *)0x203F)

int main(void)
{
    unsigned int state = GPIO_INITIAL_SEED;
    unsigned int sample = 0;

    GPIO_OUTPUT = 0;
    do {
        while ((GPIO_INPUT & 0x400u) == 0) {
        }
        state = polynomial((GPIO_INPUT & 0x3FFu) ^ state) & 0x3FFu;
        GPIO_OUTPUT = state | 0x400u;
        while ((GPIO_INPUT & 0x400u) != 0) {
        }
        GPIO_OUTPUT = state;
        sample++;
    } while (sample < GPIO_SAMPLE_COUNT);

    /* The tester requires N + 1 rising acknowledgments for N samples. */
    while ((GPIO_INPUT & 0x400u) == 0) {
    }
    GPIO_OUTPUT = state | 0x400u;

    while ((SHM_DONE & 2u) == 0) {
    }
    SHM_CT = fill_memory(SHM_CM);
    SHM_DONE = SHM_DONE | 4u;
    return 0;
}
