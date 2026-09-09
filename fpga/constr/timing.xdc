## Genesys 2 system oscillator: 200 MHz differential clock.
## The N leg is the complement and must not receive a second clock constraint.
create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports sysclk_p_i]
create_generated_clock -name pll_clk50 -source [get_pins sys_mmcm/CLKIN1] -divide_by 4 [get_pins sys_mmcm/CLKOUT0]

