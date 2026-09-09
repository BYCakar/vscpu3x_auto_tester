/*
 * gpio_xor_cm.c - VSCPU3x CodeMaker GPIO synchronizer/XOR test
 *
 * GPIO is word-addressed in the VSCPU3x shared-memory window:
 *   0x203e: GPO[10:0]
 *   0x203f: GPI[10:0]
 *
 * GPI/GPO[9:0] carry test data.  GPI/GPO[10] implement the
 * synchronizer handshake required by the auto tester.
 */

#include "generated/gpio_xor_params.h"

#define GPIO_OUTPUT (*(unsigned int *)0x203E)
#define GPIO_INPUT  (*(unsigned int *)0x203F)

#define GPIO_DATA_MASK 0x03FF
#define GPIO_SYNC_MASK 0x0400

int main(void)
{
    unsigned int seed;
    unsigned int gpio_input;
    unsigned int input_data;
    unsigned int output_data;
    int sample;

    seed = GPIO_INITIAL_SEED;
    gpio_input = 0;
    input_data = 0;
    output_data = 0;
    sample = 0;

    /* GPI[10] and GPO[10] both start low. */
    GPIO_OUTPUT = 0;

    while (sample < GPIO_SAMPLE_COUNT) {
        /* Rising edge: capture one generated 10-bit input sample. */
        while ((GPIO_INPUT & GPIO_SYNC_MASK) == 0) {
        }

        gpio_input = GPIO_INPUT;
        input_data = gpio_input & GPIO_DATA_MASK;

        /* Chain every result back as the seed for the following sample. */
        output_data = (input_data ^ seed) & GPIO_DATA_MASK;
        seed = output_data;

        /* Acknowledge high GPI[10] while presenting the XOR result. */
        GPIO_OUTPUT = output_data | GPIO_SYNC_MASK;

        /* Falling edge: retain the result and acknowledge low GPI[10]. */
        while ((GPIO_INPUT & GPIO_SYNC_MASK) != 0) {
        }
        GPIO_OUTPUT = output_data;

        sample++;
    }

    /*
     * The driver uses N + 1 rising edges for N samples.  Acknowledge the
     * final transition without consuming an additional data sample.
     */
    while ((GPIO_INPUT & GPIO_SYNC_MASK) == 0) {
    }
    GPIO_OUTPUT = output_data | GPIO_SYNC_MASK;

    return 0;
}
