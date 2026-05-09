module vscpu3x_test_top(
    // Clock, reset and enable pins
    input           i_clk,
    input           i_rst,

    // Modbus pins
    input           i_modbus_rx,
    output          o_modbus_tx,

    // VSCPU3x IO pins
    input  [37:0]   i_vscpu3x_io_in,
    output [37:0]   o_vscpu3x_io_out,
    output [37:0]   o_vscpu3x_io_oen
);

    // VSCPU3x IO signals
    wire [37:0] vscpu3x_io_in;
    wire [37:0] vscpu3x_io_out;
    wire [37:0] vscpu3x_io_oen;

    // VSCPU3x signals
    wire        vscpu3x_rst;
    wire [1:0]  vscpu3x_program_sel;

    wire [10:0] vscpu3x_gpio_in;
    wire [10:0] vscpu3x_gpio_out;

    wire        vscpu3x_rx;
    wire        vscpu3x_tx;

    wire        vscpu3x_cm_done;
    wire        vscpu3x_ct_done;
    wire        vscpu3x_agent_1_done;

    // Modbus memory interface signals
    wire [15:0] modbus_addr;
    wire        modbus_wren;
    wire        modbus_rden;
    wire [15:0] modbus_dout;
    wire [15:0] modbus_din;
    wire        modbus_wrready;

    // Modbus regspace signals
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
    wire [7:0]  gpio_pattern_len;

    wire        mrs_gpio_pattern_ready;
    wire        mrs_gpio_pattern_ren;
    wire [2:0]  mrs_gpio_pattern_wen;
    wire [7:0]  mrs_gpio_pattern_addr;

    wire [10:0] mrs_gpio_pattern_input_data;
    wire [10:0] mrs_gpio_pattern_output_chk_data;

    wire [10:0] mrs_gpio_pattern_output_act_data;

    wire [10:0] cm_proglen;
    wire [11:0] ct_proglen;
    wire [10:0] a0_proglen;

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

    // Test controller signals
    wire        gpio_pattern_rready;
    wire        gpio_pattern_rvalid;
    wire        gpio_pattern_rflush;
    wire [10:0] gpio_pattern_input_data;
    wire [10:0] gpio_pattern_output_chk_data;

    wire        gpio_pattern_wready;
    wire        gpio_pattern_wvalid;
    wire        gpio_pattern_wflush;
    wire [10:0] gpio_pattern_output_act_data;

    // Test ROM signals
    wire [10:0] testrom_cm_proglen;
    wire [11:0] testrom_ct_proglen;
    wire [10:0] testrom_a0_proglen;

    wire        testrom_progmem_ren;
    wire [1:0]  testrom_progmem_sel;
    wire [11:0] testrom_progmem_addr;
    wire [31:0] testrom_progmem_rdata;

    wire        testrom_chkmem_ren;
    wire [1:0]  testrom_chkmem_sel;
    wire [11:0] testrom_chkmem_addr;
    wire [31:0] testrom_chkmem_rdata;

    wire [7:0]  testrom_gpio_pattern_len;
    wire        testrom_gpio_pattern_rready;
    wire        testrom_gpio_pattern_rvalid;
    wire        testrom_gpio_pattern_rflush;
    wire [10:0] testrom_gpio_pattern_input_data;
    wire [10:0] testrom_gpio_pattern_output_chk_data;

    // CMD UART signals
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

    // Test driver signals
    wire        test_driver_rx;
    wire        test_driver_tx;

    // UART MUX
    assign test_driver_rx = (vscpu3x_program_sel) ? vscpu3x_rx : 1'b1;
    assign cmduart_rx = (vscpu3x_program_sel) ? 1'b1 : vscpu3x_rx;
    assign vscpu3x_tx = (vscpu3x_program_sel) ? test_driver_tx : cmduart_tx;

    /*
    vscpu3x_pinmux pinmux_inst(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_set_pinmux(set_pinmux),

        .i_vscpu3x_io_in(vscpu3x_io_in),
        .o_vscpu3x_io_out(vscpu3x_io_out),
        .o_vscpu3x_io_oen(vscpu3x_io_oen),

        .i_vscpu3x_rst(vscpu3x_rst),
        .i_vscpu3x_program_sel(vscpu3x_program_sel),
        .i_vscpu3x_gpio_in(vscpu3x_gpio_in),
        .o_vscpu3x_gpio_out(vscpu3x_gpio_out),
        .i_vscpu3x_rx(vscpu3x_rx),
        .o_vscpu3x_tx(vscpu3x_tx),
        .o_vscpu3x_cm_done(vscpu3x_cm_done),
        .o_vscpu3x_ct_done(vscpu3x_ct_done),
        .o_vscpu3x_agent_1_done(vscpu3x_agent_1_done)
    );
    */

    Modbus_Top #(
        .clk_freq(50000000), // 50 MHz clock frequency
        .baud_rate(781250) // 115200 Baud Rate
    ) modbus_controller_inst
    (
	    .i_clk(i_clk),
        .i_rst(i_rst),
        
        .o_mem_addr(modbus_addr),
        .o_mem_wren(modbus_wren),
        .o_mem_rden(modbus_rden),
        .i_mem_dout(modbus_dout),
        .o_mem_din(modbus_din),
        .i_mem_wrready(modbus_wrready),
        
        .i_rx(i_modbus_rx),
        .o_tx(o_modbus_tx)
    );

    Modbus_Regspace modbus_regspace_inst 
    (
	    .i_clk(i_clk),
        .i_rst(i_rst),

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
        .i_gpio_pattern_len(testrom_gpio_pattern_len),
        .o_gpio_pattern_len(gpio_pattern_len),

        .o_gpio_pattern_ready(mrs_gpio_pattern_ready),
        .i_gpio_pattern_ren(mrs_gpio_pattern_ren),
        .i_gpio_pattern_wen(mrs_gpio_pattern_wen),
        .i_gpio_pattern_addr(mrs_gpio_pattern_addr),

        .i_gpio_pattern_input_data(testrom_gpio_pattern_input_data),
        .i_gpio_pattern_output_chk_data(testrom_gpio_pattern_output_chk_data),
        .i_gpio_pattern_output_act_data(mrs_gpio_pattern_output_act_data),

        .o_gpio_pattern_input_data(mrs_gpio_pattern_input_data),
        .o_gpio_pattern_output_chk_data(mrs_gpio_pattern_output_chk_data),

        .o_cm_proglen(cm_proglen),
        .o_ct_proglen(ct_proglen),
        .o_a0_proglen(a0_proglen),

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

    test_controller test_controller_inst 
    (
	    .i_clk(i_clk),
        .i_rst(i_rst),

        .o_vscpu3x_rst(vscpu3x_rst),
        .o_vscpu3x_program_sel(vscpu3x_program_sel),

        .i_fetch_actmem(fetch_actmem),
        .i_fetch_progmem(fetch_progmem),
        .i_force_stop(force_stop),
        .i_test_load_run(test_load_run),
        .i_test_fast_run(test_fast_run),

        .o_progmem_loading(progmem_loading),
        .o_actmem_fetching(actmem_fetching),
        .o_progmem_fetching(progmem_fetching),
        .o_progmode(progmode),

        .o_program_error(program_error),
        .i_program_error_clr(program_error_clr),
        
        .i_testnum(testnum),
        
        .o_test_start(test_driver_start),
        .i_test_done(test_driver_done),

        .o_gpio_mismatch_clr(gpio_mismatch_clr),

        .o_gpio_pattern_len_update(gpio_pattern_len_update),
        .i_gpio_pattern_len(testrom_gpio_pattern_len),

        .i_gpio_pattern_ready(mrs_gpio_pattern_ready),
        .o_gpio_pattern_ren(mrs_gpio_pattern_ren),
        .o_gpio_pattern_wen(mrs_gpio_pattern_wen),
        .o_gpio_pattern_addr(mrs_gpio_pattern_addr),

        .o_gpio_pattern_output_act_data(mrs_gpio_pattern_output_act_data),
        .i_gpio_pattern_input_data(mrs_gpio_pattern_input_data),
        .i_gpio_pattern_output_chk_data(mrs_gpio_pattern_output_chk_data),

        .o_cm_proglen(cm_proglen),
        .o_ct_proglen(ct_proglen),
        .o_a0_proglen(a0_proglen),

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

        .o_progrom_ren(progrom_ren),
        .o_progrom_sel(progrom_sel),
        .o_progrom_addr(progrom_addr),
        .i_progrom_rdata(progrom_rdata),

        .o_chkrom_ren(chkrom_ren),
        .o_chkrom_sel(chkrom_sel),
        .o_chkrom_addr(chkrom_addr),
        .i_chkrom_rdata(chkrom_rdata),

        .o_cmduart_start(cmduart_start),
        .o_cmduart_wen(cmduart_wen),
        .i_cmduart_done(cmduart_done),
        .i_cmduart_busy(cmduart_busy),
        .i_cmduart_err(cmduart_err),
        .o_cmduart_addr(cmduart_addr),
        .i_cmduart_rdata(cmduart_rdata),
        .o_cmduart_wdata(cmduart_wdata)
    );

    /*test_driver test_driver_inst(
        .i_clk(i_clk),
        .i_rst(i_rst | soft_reset),

        .i_testnum(testnum),

        .i_test_start(test_driver_start),
        .o_test_done(test_driver_done),

        .o_test_running(test_running),
        .o_a0_running(a0_running),
        .o_ct_running(ct_running),
        .o_cm_running(cm_running),
        
        .o_uart_rx_rready(uart_tx_rready),
        .i_uart_rx_rvalid(uart_tx_rvalid),
        .o_uart_rx_rdata(uart_tx_rdata),

        .o_uart_rx_wready(uart_rx_wready),
        .i_uart_rx_wvalid(uart_rx_wvalid),
        .i_uart_rx_wdata(uart_rx_wdata),

        .o_gpio_mismatch_incr(gpio_mismatch_incr),
        .i_gpio_pattern_len(gpio_pattern_len),

        .i_gpio_pattern_rready(gpio_pattern_rready),
        .o_gpio_pattern_rvalid(gpio_pattern_rvalid),
        .i_gpio_pattern_input_data(gpio_pattern_input_data),
        .i_gpio_pattern_output_chk_data(gpio_pattern_output_chk_data),

        .i_gpio_pattern_wready(gpio_pattern_wready),
        .o_gpio_pattern_wvalid(gpio_pattern_wvalid),
        .o_gpio_pattern_output_act_data(gpio_pattern_output_act_data),

        .rx_i(test_driver_rx),
        .tx_o(test_driver_tx)
    );*/

    cmd_uart_controller cmduart_inst(
        .clk_i(i_clk),
        .rstn_i(~(i_rst | soft_reset)),
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

    /*
    test_rom test_rom_inst(
        .i_clk(i_clk),
        .i_rst(i_rst | soft_reset),

        .i_testnum(testnum),

        .o_cm_proglen(testrom_cm_proglen),
        .o_ct_proglen(testrom_ct_proglen),
        .o_a0_proglen(testrom_a0_proglen),

        .i_progmem_ren(testrom_progmem_ren),
        .i_progmem_sel(testrom_progmem_sel),
        .i_progmem_addr(testrom_progmem_addr),
        .o_progmem_rdata(testrom_progmem_rdata),

        .i_chkmem_ren(testrom_chkmem_ren),
        .i_chkmem_sel(testrom_chkmem_sel),
        .i_chkmem_addr(testrom_chkmem_addr),
        .o_chkmem_rdata(testrom_chkmem_rdata),

        .o_gpio_pattern_len(testrom_gpio_pattern_len),
        .o_gpio_pattern_rready(testrom_gpio_pattern_rready),
        .i_gpio_pattern_rvalid(testrom_gpio_pattern_rvalid),
        .i_gpio_pattern_rflush(testrom_gpio_pattern_rflush),
        .o_gpio_pattern_input_data(testrom_gpio_pattern_input_data),
        .o_gpio_pattern_output_chk_data(testrom_gpio_pattern_output_chk_data)
    );
    */


endmodule