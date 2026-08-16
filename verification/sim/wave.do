onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_clk
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_rst
add wave -noupdate -group Testbench /vscpu3x_test_tb/dut_clk
add wave -noupdate -group Testbench /vscpu3x_test_tb/dut_rst
add wave -noupdate -group Testbench /vscpu3x_test_tb/program_sel
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_io_out
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_io_oenb
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_io_in
add wave -noupdate -group Testbench /vscpu3x_test_tb/vscpu3x_io_pads
add wave -noupdate -group Testbench /vscpu3x_test_tb/dut_io_out
add wave -noupdate -group Testbench /vscpu3x_test_tb/dut_io_oen
add wave -noupdate -group Testbench /vscpu3x_test_tb/dut_io_in
add wave -noupdate -group Testbench /vscpu3x_test_tb/modbus_tx
add wave -noupdate -group Testbench /vscpu3x_test_tb/modbus_rx
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_clk
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_rst
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_modbus_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_modbus_wren
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_modbus_rden
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_modbus_dout
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_modbus_din
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_modbus_wrready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_set_pinmux
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_fetch_actmem
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_fetch_progmem
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_force_stop
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_test_load_run
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_test_fast_run
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_loading
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_actmem_fetching
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_fetching
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_test_running
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_a0_running
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_ct_running
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_cm_running
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmode
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_program_error
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_memrw_error
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_program_error_clr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_testnum
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_uart_tx_rready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_uart_tx_rvalid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_uart_tx_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_uart_rx_wready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_uart_rx_wvalid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_uart_rx_wdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_mismatch_incr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_mismatch_clr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_len_update
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_len
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_gpio_pattern_len
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_gpio_pattern_ready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_ren
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_wen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_input_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_output_chk_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_gpio_pattern_output_act_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_gpio_pattern_input_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_gpio_pattern_output_chk_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_cm_proglen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_ct_proglen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_a0_proglen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_proglen_update
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_cm_proglen_update_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_ct_proglen_update_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_a0_proglen_update_data
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_progmem_ready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_valid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_wen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_sel
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_progmem_wdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_progmem_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_mismatch_clr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_cm_mismatch_incr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_ct_mismatch_incr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_a0_mismatch_incr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_shd_mismatch_incr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_chkmem_ready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_valid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_wen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_sel
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_chkmem_wdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_chkmem_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_actmem_ready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_actmem_valid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_actmem_sel
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_actmem_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_actmem_wdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_memrw_ready
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_memrw_valid
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_memrw_wen
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_memrw_sel
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_memrw_addr
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_memrw_wdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/i_memrw_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/o_soft_reset
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/cmd_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/status_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/error_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/test_num_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_prod_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_cons_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_prod_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_cons_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_pattern_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/prog_cm_proglen_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/prog_ct_proglen_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/prog_a0_proglen_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_datalo_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_datahi_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_addr_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/soft_reset_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_buffer
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_buffer
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_input_buffer
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_output_chk_buffer
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_output_act_buffer
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/progmem_cm
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/progmem_ct
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/progmem_a0
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/progmem_shd
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/progmem_shd_mask
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_cm
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_ct
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_a0
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_shd
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_cm_mask
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_ct_mask
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_a0_mask
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_shd_mask
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/actmem_cm
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/actmem_ct
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/actmem_a0
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/actmem_shd
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_cm_mismatch_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_ct_mismatch_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_a0_mismatch_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/chkmem_shd_mismatch_reg
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/error_flag
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_done
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_newdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_newdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/test_done
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_error
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_overflow
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_overflow
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_mismatch
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/shd_chk_mismatch
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/a0_chk_mismatch
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/ct_chk_mismatch
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/cm_chk_mismatch
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_prod
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_cons
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_prod
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_cons
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_tx_buffer_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/uart_rx_buffer_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_mismatch_count
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_input_buffer_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_output_chk_buffer_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/gpio_output_act_buffer_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/actmem_rdata
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/modbus_addr_q1
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/memrw_ready_q1
add wave -noupdate -group {Modbus Regspace} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_regspace_inst/test_running_q1
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/device_id
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/clk_freq
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/baud_rate
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/IDLE
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/RECEIVE_REQUEST
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/CHECK_ERRORS
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/MEM_WRITE
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/MEM_READ
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/SEND_RESPONSE
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/clkdiv
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/timeout_count
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_clk
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_rst
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/o_mem_addr
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/o_mem_wren
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/o_mem_rden
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_mem_dout
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/o_mem_din
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_mem_wrready
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_rx
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/o_tx
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/i_enable
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_tx_data
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_tx_ready
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_tx_wren
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_rx_data
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_rx_ready
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_rx_rden
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_soft_rst
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_data
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_start
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_crc16
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_done
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_soft_rst
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_din
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_dout
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_re
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_we
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/id
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/func
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/start_addr
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/quantity
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/byte_count
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc16
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/errcode
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_func
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_start_addr
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_quantity
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_byte_count
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_data
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/receive_crc
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_id
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_func
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_start_addr
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_quantity
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_byte_count
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_data
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_crc
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/send_errcode
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_rx_data_q0
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/uart_rx_data_q1
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_din_reg
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/fifo_data_ready
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/crc_enable
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/byte_counter
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/timeout_counter
add wave -noupdate -group {Modbus Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/modbus_controller_inst/state
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_IDLE
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_ROM_SECTION
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_SECTION
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_READ
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_START
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_SHD_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_SHD_MASK_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_SHD_READ
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_LOAD_SHD_READ_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_RUN
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_FETCH_SECTION
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_FETCH_START
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_FETCH_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_SECTION
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_READ
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_CHECK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_EXPECT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_EXPECT_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_START
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MASK_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MEMRW_START
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_MEMRW_WAIT
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/S_ROM_WRITE
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CM_PROG
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CT_PROG
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_A0_PROG
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_SHD_PROG
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_SHD_PROG_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CM_CHK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CT_CHK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_A0_CHK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_SHD_CHK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CM_CHK_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_CT_CHK_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_A0_CHK_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_SHD_CHK_MASK
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_GPIO
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SEC_DONE
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/CM_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/CT_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/A0_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SHD_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/CM_MASK_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/CT_MASK_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/A0_MASK_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/SHD_MASK_WORDS
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_clk
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_rst
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_vscpu3x_rst
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_vscpu3x_program_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cm_done
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_ct_done
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_a0_done
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_fetch_actmem
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_fetch_progmem
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_force_stop
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_test_load_run
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_test_fast_run
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_loading
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_actmem_fetching
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_fetching
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmode
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_test_running
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_a0_running
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_ct_running
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cm_running
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_program_error
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_program_error_clr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_memrw_error
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_test_start
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_testnum
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_mismatch_clr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_len_update
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_len_update_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_gpio_pattern_ready
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_ren
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_wen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_input_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_output_chk_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_pattern_output_act_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cm_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_ct_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_a0_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_proglen_update
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cm_proglen_update_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_ct_proglen_update_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_a0_proglen_update_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_progmem_ready
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_valid
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_wen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progmem_wdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_progmem_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_mismatch_clr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_cm_mismatch_incr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_ct_mismatch_incr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_a0_mismatch_incr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_shd_mismatch_incr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_chkmem_ready
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_valid
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_wen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkmem_wdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_chkmem_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_actmem_ready
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_actmem_valid
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_actmem_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_actmem_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_actmem_wdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_memrw_ready
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_memrw_valid
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_memrw_wen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_memrw_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_memrw_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_memrw_wdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_memrw_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_rom_cm_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_rom_ct_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_rom_a0_proglen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_rom_gpio_pattern_len
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progrom_ren
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progrom_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_progrom_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_progrom_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkrom_ren
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkrom_sel
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_chkrom_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_chkrom_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_gpio_rom_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_gpio_rom_input_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_gpio_rom_output_chk_data
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cmduart_start
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cmduart_wen
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cmduart_done
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cmduart_busy
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cmduart_err
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cmduart_addr
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_cmduart_rdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/o_cmduart_wdata
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/i_test_driver_done
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/state
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/section
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/fast_run_pending
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/loading_shared
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/word_idx
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/mask_word
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/expected_word
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/program_error_reg
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/done_meta
add wave -noupdate -group {Test Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/test_controller_inst/done_sync
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_clkdiv
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_W
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_R
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_0
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_9
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_A
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/CHAR_F
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_IDLE
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_RD_READDATA
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_RD_DATARCV
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_RD_COMPARE
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_WR_SETADDR
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_WR_WRITEDATA
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_WR_READBACK
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_WR_DATARCV
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/S_WR_COMPARE
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/MAX_WR_RETRY
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/clk_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/rstn_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/enable_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/start_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/wen_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/done_o
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/busy_o
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/err_o
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/addr_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/rdata_o
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/wdata_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/rx_i
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/tx_o
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_rx_rden
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_rx_rden_q1
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_tx_wren
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_tx_data
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_tx_ready
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_rx_ready
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_rx_fifo_overflow
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_rx_data
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_rddata
add wave -noupdate -group {CMDUART Controller} -radix ascii /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_rdcmd
add wave -noupdate -group {CMDUART Controller} -radix ascii -childformat {{{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[0]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[1]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[2]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[3]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[4]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[5]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[6]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[7]} -radix ascii} {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[8]} -radix ascii}} -subitemconfig {{/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[0]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[1]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[2]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[3]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[4]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[5]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[6]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[7]} {-height 20 -radix ascii} {/vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd[8]} {-height 20 -radix ascii}} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/buf_wrcmd
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/state
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/retry_count
add wave -noupdate -group {CMDUART Controller} /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/data_count
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/clkdiv
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/fifo_w
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_clk
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_rst
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_enable
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_tx_data
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/o_tx_ready
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_tx_wren
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/o_rx_data
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/o_rx_ready
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_rx_rden
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/o_rx_fifo_overflow
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/i_rx
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/o_tx
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/uart_rx_dv
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/uart_rx_byte
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/uart_tx_dv
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/uart_tx_byte
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/uart_tx_active
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/rx_fifo_empty
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/rx_fifo_full
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/rx_fifo_err
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/tx_fifo_empty
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/tx_fifo_full
add wave -noupdate -group CMDUART /vscpu3x_test_tb/dut/auto_tester_top_inst/cmduart_inst/uart_inst/tx_fifo_rden
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/BITS
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wb_clk_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wb_rst_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_stb_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_cyc_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_we_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_sel_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_dat_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_adr_i
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_ack_o
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wbs_dat_o
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/la_data_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/la_data_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/la_oenb
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/io_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/io_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/io_oeb
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/analog_io
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/user_clock2
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/user_irq
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/clk
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rst
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/program_sel
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/gpio_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/gpio_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/dvsr
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rx
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/tx
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_done
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_done
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_done
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rst_asserted
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_we
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_addr
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_req
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_mem_ctrl_vld
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram0_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram0_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram0_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram1_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram1_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram1_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram2_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram2_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram2_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram3_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram3_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram3_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram4_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram4_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram4_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram_comm_addr0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/agent_1_sram_comm_din0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_we
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_addr
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_req
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_mem_ctrl_vld
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram0_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram0_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram0_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram1_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram1_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram1_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram2_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram2_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram2_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram3_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram3_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram3_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram4_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram4_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram4_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram5_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram5_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram5_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram_comm_addr0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/cm_sram_comm_din0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_we
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_addr
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_req
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_mem_ctrl_vld
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram0_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram0_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram0_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram1_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram1_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram1_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram2_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram2_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram2_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram3_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram3_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram3_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram4_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram4_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram4_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram5_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram5_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram5_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram6_csb0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram6_web0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram6_dout0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram_comm_addr0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/ct_sram_comm_din0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/sram_const_wmask0
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/sram_const_csb1
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/sram_const_addr1
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/main_mem_we
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/main_mem_addr
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/main_mem_in
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/main_mem_out
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rx_fifo_flush_enable
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rd_uart
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/wr_uart
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/w_data
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/tx_full
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/rx_empty
add wave -noupdate -group VSCPU3x /vscpu3x_test_tb/vscpu3x/r_data
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/clk
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/rst
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/program_sel
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cp_mem_ctrl_we
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cp_mem_ctrl_addr
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cp_mem_ctrl_in
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cp_mem_ctrl_out
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram0_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram0_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram0_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram1_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram1_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram1_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram2_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram2_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram2_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram3_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram3_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram3_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram4_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram4_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram4_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram5_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram5_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/cm_sram5_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram0_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram0_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram0_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram1_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram1_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram1_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram2_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram2_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram2_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram3_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram3_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram3_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram4_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram4_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram4_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram5_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram5_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram5_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram6_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram6_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/ct_sram6_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram0_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram0_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram0_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram1_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram1_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram1_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram2_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram2_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram2_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram3_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram3_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram3_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram4_csb0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram4_web0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/agent_1_sram4_dout0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/sram_comm_addr0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/sram_comm_din0
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/main_mem_we
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/main_mem_addr
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/main_mem_in
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/main_mem_out
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/SRAM_dout_sel
add wave -noupdate -group {CP Memory Controller} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_command_processor_mem_controller/VSCPU_dout_sel
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/STATE_WAIT_RX
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/STATE_READ_RX
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/STATE_WRITE_TX
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/STATE_READ_MEM
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_W
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_R
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_0
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_9
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_A
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/CHAR_F
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/clk
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/rst
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/enable
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/mem_wea
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/mem_addra
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/mem_dina
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/mem_douta
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/rx_fifo_flush_enable
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/rd_uart
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/wr_uart
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/w_data
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/tx_full
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/rx_empty
add wave -noupdate -group {Command Processor} -radix ascii /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/r_data
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/state
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/command_read
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/command_write
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/obtained_mem_data
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/byte_count
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/addr_pointer
add wave -noupdate -group {Command Processor} /vscpu3x_test_tb/vscpu3x/inst_main_controller/inst_uart_cp/data_to_send
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/SIZE
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/clk
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/rst
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/debug_en
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/debug_pc_out
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/data_fromRAM
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/wrEn
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/addr_toRAM
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/data_toRAM
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/mem_vld
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/mem_req
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/done
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/state_current
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/state_next
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/pc_current
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/pc_next
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/pc_last
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/iw_current
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/iw_next
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/r1_current
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/r1_next
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/r2_current
add wave -noupdate -group Codemaker /vscpu3x_test_tb/vscpu3x/inst_codemaker/inst_VerySimpleCPU/r2_next
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/SIZE
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/clk
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/rst
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/debug_en
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/debug_pc_out
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/data_fromRAM
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/wrEn
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/addr_toRAM
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/data_toRAM
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/mem_vld
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/mem_req
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/done
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/state_current
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/state_next
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/pc_current
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/pc_next
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/pc_last
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/iw_current
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/iw_next
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/r1_current
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/r1_next
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/r2_current
add wave -noupdate -group {Control Tower} /vscpu3x_test_tb/vscpu3x/inst_control_tower/inst_VerySimpleCPU/r2_next
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/SIZE
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/clk
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/rst
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/debug_en
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/debug_pc_out
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/data_fromRAM
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/wrEn
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/addr_toRAM
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/data_toRAM
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/mem_vld
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/mem_req
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/done
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/state_current
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/state_next
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/pc_current
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/pc_next
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/pc_last
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/iw_current
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/iw_next
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/r1_current
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/r1_next
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/r2_current
add wave -noupdate -group {Agent 0} /vscpu3x_test_tb/vscpu3x/inst_agent_1/inst_VerySimpleCPU/r2_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1608841215880 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {7175724296452 ps}
