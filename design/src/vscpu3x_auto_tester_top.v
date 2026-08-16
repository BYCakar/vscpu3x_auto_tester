module vscpu3x_auto_tester_top #(
    parameter integer SYS_CLK_HZ    = 50000000,
    parameter integer MODBUS_BAUD   = 115200,
    parameter integer CUT_UART_BAUD = 115200
) (
    input               clk_i,
    input               rst_i,

    input               modbus_uart_rx_i,
    output              modbus_uart_tx_o,

    output              cut_reset_o,
    output      [1:0]   cut_program_sel_o,
    output              cut_uart_rx_o,
    input               cut_uart_tx_i,
    input       [2:0]   cut_done_i,
    output      [10:0]  cut_gpio_in_o,
    input       [10:0]  cut_gpio_out_i,

    output              pinmux_enable_o
);

    localparam integer UART_CLKDIV = SYS_CLK_HZ / CUT_UART_BAUD;
    localparam integer GPIO_HALF_PERIOD_CYCLES = SYS_CLK_HZ / 200;

    wire [15:0] modbus_addr;
    wire        modbus_wren;
    wire        modbus_rden;
    wire [15:0] modbus_dout;
    wire [15:0] modbus_din;
    wire        modbus_wrready;

    wire        set_pinmux;
    wire        fetch_actmem;
    wire        fetch_progmem;
    wire        force_stop;
    wire        test_load_run;
    wire        test_fast_run;

    wire        progmem_loading;
    wire        actmem_fetching;
    wire        progmem_fetching;
    wire        test_running;
    wire        a0_running;
    wire        ct_running;
    wire        cm_running;
    wire        progmode;
    wire        program_error;
    wire        program_error_clr;
    wire        memrw_error;

    wire [3:0]  testnum;

    wire        uart_tx_rready;
    wire        uart_tx_rvalid;
    wire [7:0]  uart_tx_rdata;
    wire        uart_rx_wready;
    wire        uart_rx_wvalid;
    wire [7:0]  uart_rx_wdata;

    wire        gpio_mismatch_incr;
    wire        gpio_mismatch_clr;
    wire        gpio_pattern_len_update;
    wire [7:0]  gpio_pattern_len_update_data;
    wire [7:0]  gpio_pattern_len;

    wire        gpio_pattern_ready;
    wire        gpio_pattern_ren;
    wire [2:0]  gpio_pattern_wen;
    wire [7:0]  gpio_pattern_addr;
    wire [10:0] gpio_pattern_input_data_to_regspace;
    wire [10:0] gpio_pattern_output_chk_data_to_regspace;
    wire [10:0] gpio_pattern_output_act_data_to_regspace;
    wire        ctrl_gpio_pattern_ren;
    wire [2:0]  ctrl_gpio_pattern_wen;
    wire [7:0]  ctrl_gpio_pattern_addr;
    wire [10:0] ctrl_gpio_pattern_input_data;
    wire [10:0] ctrl_gpio_pattern_output_chk_data;
    wire [10:0] ctrl_gpio_pattern_output_act_data;
    wire        driver_gpio_pattern_ren;
    wire [2:0]  driver_gpio_pattern_wen;
    wire [7:0]  driver_gpio_pattern_addr;
    wire [10:0] driver_gpio_pattern_output_act_data;
    wire [10:0] gpio_pattern_input_data_from_regspace;
    wire [10:0] gpio_pattern_output_chk_data_from_regspace;

    wire [10:0] cm_proglen;
    wire [11:0] ct_proglen;
    wire [10:0] a0_proglen;
    wire        proglen_update;
    wire [10:0] cm_proglen_update_data;
    wire [11:0] ct_proglen_update_data;
    wire [10:0] a0_proglen_update_data;

    wire        progmem_ready;
    wire        progmem_valid;
    wire        progmem_wen;
    wire [1:0]  progmem_sel;
    wire [11:0] progmem_addr;
    wire [31:0] progmem_wdata;
    wire [31:0] progmem_rdata;

    wire        chkmem_mismatch_clr;
    wire        chkmem_cm_mismatch_incr;
    wire        chkmem_ct_mismatch_incr;
    wire        chkmem_a0_mismatch_incr;
    wire        chkmem_shd_mismatch_incr;
    wire        chkmem_ready;
    wire        chkmem_valid;
    wire        chkmem_wen;
    wire [1:0]  chkmem_sel;
    wire [11:0] chkmem_addr;
    wire [31:0] chkmem_wdata;
    wire [31:0] chkmem_rdata;

    wire        actmem_ready;
    wire        actmem_valid;
    wire [1:0]  actmem_sel;
    wire [11:0] actmem_addr;
    wire [31:0] actmem_wdata;

    wire        memrw_ready;
    wire        memrw_valid;
    wire        memrw_wen;
    wire [1:0]  memrw_sel;
    wire [11:0] memrw_addr;
    wire [31:0] memrw_wdata;
    wire [31:0] memrw_rdata;
    wire        soft_reset;

    wire [10:0] rom_cm_proglen;
    wire [11:0] rom_ct_proglen;
    wire [10:0] rom_a0_proglen;
    wire [7:0]  rom_gpio_pattern_len;
    wire        progrom_ren;
    wire [1:0]  progrom_sel;
    wire [11:0] progrom_addr;
    wire [31:0] progrom_rdata;
    wire        chkrom_ren;
    wire [1:0]  chkrom_sel;
    wire [11:0] chkrom_addr;
    wire [31:0] chkrom_rdata;
    wire [7:0]  gpio_rom_addr;
    wire [10:0] gpio_rom_input_data;
    wire [10:0] gpio_rom_output_chk_data;

    wire        cmduart_start;
    wire        cmduart_wen;
    wire        cmduart_done;
    wire        cmduart_busy;
    wire        cmduart_err;
    wire [13:0] cmduart_addr;
    wire [31:0] cmduart_rdata;
    wire [31:0] cmduart_wdata;
    wire        cmduart_rx;
    wire        cmduart_tx;

    wire        driver_rx;
    wire        driver_tx;
    wire        test_driver_done;
    wire        test_driver_start;

    wire        tester_cut_reset;
    wire [1:0]  tester_program_sel;
    wire        tester_uart_rx_to_cut;
    wire [10:0] tester_gpio_in;
    wire        tester_uart_tx_from_cut;
    wire [2:0]  tester_done;
    wire [10:0] tester_gpio_out;
    wire        use_driver_gpio_port;

    assign cmduart_rx  = (|tester_program_sel) ? tester_uart_tx_from_cut : 1'b1;
    assign driver_rx   = (|tester_program_sel) ? 1'b1 : tester_uart_tx_from_cut;
    assign tester_uart_rx_to_cut = (|tester_program_sel) ? cmduart_tx : driver_tx;
    assign use_driver_gpio_port = test_running && !(|tester_program_sel);
    assign gpio_pattern_ren = (use_driver_gpio_port) ? driver_gpio_pattern_ren : ctrl_gpio_pattern_ren;
    assign gpio_pattern_wen = (use_driver_gpio_port) ? driver_gpio_pattern_wen : ctrl_gpio_pattern_wen;
    assign gpio_pattern_addr = (use_driver_gpio_port) ? driver_gpio_pattern_addr : ctrl_gpio_pattern_addr;
    assign gpio_pattern_input_data_to_regspace = ctrl_gpio_pattern_input_data;
    assign gpio_pattern_output_chk_data_to_regspace = ctrl_gpio_pattern_output_chk_data;
    assign gpio_pattern_output_act_data_to_regspace = (use_driver_gpio_port) ?
                                                       driver_gpio_pattern_output_act_data :
                                                       ctrl_gpio_pattern_output_act_data;

    Modbus_Top #(
        .clk_freq(SYS_CLK_HZ),
        .baud_rate(MODBUS_BAUD)
    ) modbus_controller_inst (
        .i_clk(clk_i),
        .i_rst(rst_i),

        .o_mem_addr(modbus_addr),
        .o_mem_wren(modbus_wren),
        .o_mem_rden(modbus_rden),
        .i_mem_dout(modbus_dout),
        .o_mem_din(modbus_din),
        .i_mem_wrready(modbus_wrready),

        .i_rx(modbus_uart_rx_i),
        .o_tx(modbus_uart_tx_o)
    );

    Modbus_Regspace modbus_regspace_inst (
        .i_clk(clk_i),
        .i_rst(rst_i),

        .i_modbus_addr(modbus_addr),
        .i_modbus_wren(modbus_wren),
        .i_modbus_rden(modbus_rden),
        .o_modbus_dout(modbus_dout),
        .i_modbus_din(modbus_din),
        .o_modbus_wrready(modbus_wrready),

        .o_set_pinmux(set_pinmux),
        .o_fetch_actmem(fetch_actmem),
        .o_fetch_progmem(fetch_progmem),
        .o_force_stop(force_stop),
        .o_test_load_run(test_load_run),
        .o_test_fast_run(test_fast_run),

        .i_progmem_loading(progmem_loading),
        .i_actmem_fetching(actmem_fetching),
        .i_progmem_fetching(progmem_fetching),
        .i_test_running(test_running),
        .i_a0_running(a0_running),
        .i_ct_running(ct_running),
        .i_cm_running(cm_running),
        .i_progmode(progmode),

        .i_program_error(program_error),
        .o_program_error_clr(program_error_clr),
        .i_memrw_error(memrw_error),

        .o_testnum(testnum),

        .o_uart_tx_rready(uart_tx_rready),
        .i_uart_tx_rvalid(uart_tx_rvalid),
        .o_uart_tx_rdata(uart_tx_rdata),

        .o_uart_rx_wready(uart_rx_wready),
        .i_uart_rx_wvalid(uart_rx_wvalid),
        .i_uart_rx_wdata(uart_rx_wdata),

        .i_gpio_mismatch_incr(gpio_mismatch_incr),
        .i_gpio_mismatch_clr(gpio_mismatch_clr),
        .i_gpio_pattern_len_update(gpio_pattern_len_update),
        .i_gpio_pattern_len(gpio_pattern_len_update_data),
        .o_gpio_pattern_len(gpio_pattern_len),

        .o_gpio_pattern_ready(gpio_pattern_ready),
        .i_gpio_pattern_ren(gpio_pattern_ren),
        .i_gpio_pattern_wen(gpio_pattern_wen),
        .i_gpio_pattern_addr(gpio_pattern_addr),
        .i_gpio_pattern_input_data(gpio_pattern_input_data_to_regspace),
        .i_gpio_pattern_output_chk_data(gpio_pattern_output_chk_data_to_regspace),
        .i_gpio_pattern_output_act_data(gpio_pattern_output_act_data_to_regspace),
        .o_gpio_pattern_input_data(gpio_pattern_input_data_from_regspace),
        .o_gpio_pattern_output_chk_data(gpio_pattern_output_chk_data_from_regspace),

        .o_cm_proglen(cm_proglen),
        .o_ct_proglen(ct_proglen),
        .o_a0_proglen(a0_proglen),
        .i_proglen_update(proglen_update),
        .i_cm_proglen_update_data(cm_proglen_update_data),
        .i_ct_proglen_update_data(ct_proglen_update_data),
        .i_a0_proglen_update_data(a0_proglen_update_data),

        .o_progmem_ready(progmem_ready),
        .i_progmem_valid(progmem_valid),
        .i_progmem_wen(progmem_wen),
        .i_progmem_sel(progmem_sel),
        .i_progmem_addr(progmem_addr),
        .i_progmem_wdata(progmem_wdata),
        .o_progmem_rdata(progmem_rdata),

        .i_chkmem_mismatch_clr(chkmem_mismatch_clr),
        .i_chkmem_cm_mismatch_incr(chkmem_cm_mismatch_incr),
        .i_chkmem_ct_mismatch_incr(chkmem_ct_mismatch_incr),
        .i_chkmem_a0_mismatch_incr(chkmem_a0_mismatch_incr),
        .i_chkmem_shd_mismatch_incr(chkmem_shd_mismatch_incr),
        .o_chkmem_ready(chkmem_ready),
        .i_chkmem_valid(chkmem_valid),
        .i_chkmem_wen(chkmem_wen),
        .i_chkmem_sel(chkmem_sel),
        .i_chkmem_addr(chkmem_addr),
        .i_chkmem_wdata(chkmem_wdata),
        .o_chkmem_rdata(chkmem_rdata),

        .o_actmem_ready(actmem_ready),
        .i_actmem_valid(actmem_valid),
        .i_actmem_sel(actmem_sel),
        .i_actmem_addr(actmem_addr),
        .i_actmem_wdata(actmem_wdata),

        .i_memrw_ready(memrw_ready),
        .o_memrw_valid(memrw_valid),
        .o_memrw_wen(memrw_wen),
        .o_memrw_sel(memrw_sel),
        .o_memrw_addr(memrw_addr),
        .o_memrw_wdata(memrw_wdata),
        .i_memrw_rdata(memrw_rdata),

        .o_soft_reset(soft_reset)
    );

    test_controller #(.PROGRAM_SEL_MARGIN_CYCLES(300), .RESET_PULSE_CYCLES(50)) test_controller_inst (
        .i_clk(clk_i),
        .i_rst(rst_i | soft_reset),

        .o_vscpu3x_rst(tester_cut_reset),
        .o_vscpu3x_program_sel(tester_program_sel),
        .i_cm_done(tester_done[0]),
        .i_ct_done(tester_done[1]),
        .i_a0_done(tester_done[2]),

        .i_fetch_actmem(fetch_actmem),
        .i_fetch_progmem(fetch_progmem),
        .i_force_stop(force_stop),
        .i_test_load_run(test_load_run),
        .i_test_fast_run(test_fast_run),

        .o_progmem_loading(progmem_loading),
        .o_actmem_fetching(actmem_fetching),
        .o_progmem_fetching(progmem_fetching),
        .o_progmode(progmode),
        .o_test_running(test_running),
        .o_a0_running(a0_running),
        .o_ct_running(ct_running),
        .o_cm_running(cm_running),

        .o_program_error(program_error),
        .i_program_error_clr(program_error_clr),
        .o_memrw_error(memrw_error),
        .o_test_start(test_driver_start),

        .i_testnum(testnum),

        .o_gpio_mismatch_clr(gpio_mismatch_clr),
        .o_gpio_pattern_len_update(gpio_pattern_len_update),
        .o_gpio_pattern_len_update_data(gpio_pattern_len_update_data),

        .i_gpio_pattern_ready(gpio_pattern_ready),
        .o_gpio_pattern_ren(ctrl_gpio_pattern_ren),
        .o_gpio_pattern_wen(ctrl_gpio_pattern_wen),
        .o_gpio_pattern_addr(ctrl_gpio_pattern_addr),
        .o_gpio_pattern_input_data(ctrl_gpio_pattern_input_data),
        .o_gpio_pattern_output_chk_data(ctrl_gpio_pattern_output_chk_data),
        .o_gpio_pattern_output_act_data(ctrl_gpio_pattern_output_act_data),

        .i_cm_proglen(cm_proglen),
        .i_ct_proglen(ct_proglen),
        .i_a0_proglen(a0_proglen),
        .o_proglen_update(proglen_update),
        .o_cm_proglen_update_data(cm_proglen_update_data),
        .o_ct_proglen_update_data(ct_proglen_update_data),
        .o_a0_proglen_update_data(a0_proglen_update_data),

        .i_progmem_ready(progmem_ready),
        .o_progmem_valid(progmem_valid),
        .o_progmem_wen(progmem_wen),
        .o_progmem_sel(progmem_sel),
        .o_progmem_addr(progmem_addr),
        .o_progmem_wdata(progmem_wdata),
        .i_progmem_rdata(progmem_rdata),

        .o_chkmem_mismatch_clr(chkmem_mismatch_clr),
        .o_chkmem_cm_mismatch_incr(chkmem_cm_mismatch_incr),
        .o_chkmem_ct_mismatch_incr(chkmem_ct_mismatch_incr),
        .o_chkmem_a0_mismatch_incr(chkmem_a0_mismatch_incr),
        .o_chkmem_shd_mismatch_incr(chkmem_shd_mismatch_incr),

        .i_chkmem_ready(chkmem_ready),
        .o_chkmem_valid(chkmem_valid),
        .o_chkmem_wen(chkmem_wen),
        .o_chkmem_sel(chkmem_sel),
        .o_chkmem_addr(chkmem_addr),
        .o_chkmem_wdata(chkmem_wdata),
        .i_chkmem_rdata(chkmem_rdata),

        .i_actmem_ready(actmem_ready),
        .o_actmem_valid(actmem_valid),
        .o_actmem_sel(actmem_sel),
        .o_actmem_addr(actmem_addr),
        .o_actmem_wdata(actmem_wdata),

        .o_memrw_ready(memrw_ready),
        .i_memrw_valid(memrw_valid),
        .i_memrw_wen(memrw_wen),
        .i_memrw_sel(memrw_sel),
        .i_memrw_addr(memrw_addr),
        .i_memrw_wdata(memrw_wdata),
        .o_memrw_rdata(memrw_rdata),

        .i_rom_cm_proglen(rom_cm_proglen),
        .i_rom_ct_proglen(rom_ct_proglen),
        .i_rom_a0_proglen(rom_a0_proglen),
        .i_rom_gpio_pattern_len(rom_gpio_pattern_len),

        .o_progrom_ren(progrom_ren),
        .o_progrom_sel(progrom_sel),
        .o_progrom_addr(progrom_addr),
        .i_progrom_rdata(progrom_rdata),
        .o_chkrom_ren(chkrom_ren),
        .o_chkrom_sel(chkrom_sel),
        .o_chkrom_addr(chkrom_addr),
        .i_chkrom_rdata(chkrom_rdata),
        .o_gpio_rom_addr(gpio_rom_addr),
        .i_gpio_rom_input_data(gpio_rom_input_data),
        .i_gpio_rom_output_chk_data(gpio_rom_output_chk_data),

        .o_cmduart_start(cmduart_start),
        .o_cmduart_wen(cmduart_wen),
        .i_cmduart_done(cmduart_done),
        .i_cmduart_busy(cmduart_busy),
        .i_cmduart_err(cmduart_err),
        .o_cmduart_addr(cmduart_addr),
        .i_cmduart_rdata(cmduart_rdata),
        .o_cmduart_wdata(cmduart_wdata),

        .i_test_driver_done(test_driver_done)
    );

    test_driver #(
        .uart_clkdiv(UART_CLKDIV),
        .gpio_half_period_cycles(GPIO_HALF_PERIOD_CYCLES)
    ) test_driver_inst (
        .i_clk(clk_i),
        .i_rst(rst_i | soft_reset),
        .i_functional_mode(~|tester_program_sel),
        .i_test_active(test_running),
        .i_test_start(test_driver_start),
        .o_test_done(test_driver_done),

        .i_uart_tx_rready(uart_tx_rready),
        .o_uart_tx_rvalid(uart_tx_rvalid),
        .i_uart_tx_rdata(uart_tx_rdata),
        .i_uart_rx_wready(uart_rx_wready),
        .o_uart_rx_wvalid(uart_rx_wvalid),
        .o_uart_rx_wdata(uart_rx_wdata),

        .o_gpio_mismatch_incr(gpio_mismatch_incr),
        .i_gpio_pattern_len(gpio_pattern_len),
        .i_gpio_pattern_ready(gpio_pattern_ready),
        .o_gpio_pattern_ren(driver_gpio_pattern_ren),
        .o_gpio_pattern_wen(driver_gpio_pattern_wen),
        .o_gpio_pattern_addr(driver_gpio_pattern_addr),
        .i_gpio_pattern_input_data(gpio_pattern_input_data_from_regspace),
        .i_gpio_pattern_output_chk_data(gpio_pattern_output_chk_data_from_regspace),
        .o_gpio_pattern_output_act_data(driver_gpio_pattern_output_act_data),

        .o_vscpu3x_gpio_in(tester_gpio_in),
        .i_vscpu3x_gpio_out(tester_gpio_out),
        .i_rx(driver_rx),
        .o_tx(driver_tx)
    );

    test_rom test_rom_inst (
        .i_clk(clk_i),
        .i_rst(rst_i),
        .i_testnum(testnum),

        .o_cm_proglen(rom_cm_proglen),
        .o_ct_proglen(rom_ct_proglen),
        .o_a0_proglen(rom_a0_proglen),
        .o_gpio_pattern_len(rom_gpio_pattern_len),

        .i_progmem_ren(progrom_ren),
        .i_progmem_sel(progrom_sel),
        .i_progmem_addr(progrom_addr),
        .o_progmem_rdata(progrom_rdata),
        .i_chkmem_ren(chkrom_ren),
        .i_chkmem_sel(chkrom_sel),
        .i_chkmem_addr(chkrom_addr),
        .o_chkmem_rdata(chkrom_rdata),
        .i_gpio_pattern_addr(gpio_rom_addr),
        .o_gpio_pattern_input_data(gpio_rom_input_data),
        .o_gpio_pattern_output_chk_data(gpio_rom_output_chk_data)
    );

    cmd_uart_controller #(
        .uart_clkdiv(UART_CLKDIV) // ,
        // .timeout_cycles(SYS_CLK_HZ / 10)
    ) cmduart_inst (
        .clk_i(clk_i),
        .rstn_i(~(rst_i | soft_reset)),
        .enable_i(1'b1),

        .start_i(cmduart_start),
        .wen_i(cmduart_wen),
        .done_o(cmduart_done),
        .busy_o(cmduart_busy),
        .err_o(cmduart_err),
        .addr_i(cmduart_addr),
        .rdata_o(cmduart_rdata),
        .wdata_i(cmduart_wdata),

        .rx_i(cmduart_rx),
        .tx_o(cmduart_tx)
    );

    vscpu3x_pinmux pinmux_inst (
        .i_clk(clk_i),
        .i_rst(rst_i | soft_reset),

        .i_set_pinmux_bp(set_pinmux),

        .i_tester_cut_reset(tester_cut_reset),
        .i_tester_program_sel(tester_program_sel),
        .i_tester_uart_rx(tester_uart_rx_to_cut),
        .i_tester_gpio_in(tester_gpio_in),

        .o_cut_reset(cut_reset_o),
        .o_cut_program_sel(cut_program_sel_o),
        .o_cut_uart_rx(cut_uart_rx_o),
        .o_cut_gpio_in(cut_gpio_in_o),

        .i_cut_uart_tx(cut_uart_tx_i),
        .i_cut_done(cut_done_i),
        .i_cut_gpio_out(cut_gpio_out_i),

        .o_tester_uart_tx(tester_uart_tx_from_cut),
        .o_tester_done(tester_done),
        .o_tester_gpio_out(tester_gpio_out),
        .o_pinmux_enable(pinmux_enable_o)
    );

endmodule
