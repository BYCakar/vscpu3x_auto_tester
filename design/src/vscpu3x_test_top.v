module vscpu3x_test_top(
    input           i_clk,
    input           i_rst,

    input           i_modbus_rx,
    output          o_modbus_tx,

    input  [37:0]   i_vscpu3x_io_in,
    output [37:0]   o_vscpu3x_io_out,
    output [37:0]   o_vscpu3x_io_oen
);

    wire        cut_reset;
    wire [1:0]  cut_program_sel;
    wire        cut_uart_rx;
    wire [10:0] cut_gpio_in;
    wire        pinmux_enable;

    assign o_vscpu3x_io_out = {
        11'h0,
        cut_gpio_in,
        4'h0,
        cut_uart_rx,
        cut_program_sel[1],
        cut_program_sel[0],
        cut_reset,
        8'h0
    };

    assign o_vscpu3x_io_oen = {
        11'h0,
        {11{pinmux_enable}},
        4'h0,
        {4{pinmux_enable}},
        8'h0
    };

    vscpu3x_auto_tester_top #(
        .SYS_CLK_HZ(50000000),
        .MODBUS_BAUD(3125000),
        .CUT_UART_BAUD(3125000))
    auto_tester_top_inst
    (
        .clk_i(i_clk),
        .rst_i(i_rst),

        .modbus_uart_rx_i(i_modbus_rx),
        .modbus_uart_tx_o(o_modbus_tx),

        .cut_reset_o(cut_reset),
        .cut_program_sel_o(cut_program_sel),
        .cut_uart_rx_o(cut_uart_rx),
        .cut_uart_tx_i(i_vscpu3x_io_in[12]),
        .cut_done_i({i_vscpu3x_io_in[15], i_vscpu3x_io_in[14], i_vscpu3x_io_in[13]}),
        .cut_gpio_in_o(cut_gpio_in),
        .cut_gpio_out_i(i_vscpu3x_io_in[37:27]),

        .pinmux_enable_o(pinmux_enable)
    );

endmodule
