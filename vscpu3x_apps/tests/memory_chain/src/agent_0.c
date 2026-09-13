#include "generated/memory_chain_a0_params.h"
#include "common.h"

int main(void)
{
    SHM_A0 = fill_memory(A0_SEED);
    SHM_DONE = SHM_DONE | 1u;
    return 0;
}
