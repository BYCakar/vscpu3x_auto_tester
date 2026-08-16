module fpga_wrapper #(
    parameter integer BOARD_CLK_HZ = 200000000,
    parameter integer SYS_CLK_HZ    = 50000000,
    parameter integer MODBUS_BAUD   = 115200,
    parameter integer CUT_UART_BAUD = 115200
) (
    input               board_clk_i,
    input               reset_btn_i,

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

    wire clkfb;
    wire clkfb_buf;
    wire clk_50m_unbuf;
    wire sys_clk;
    wire mmcm_locked;

    reg [3:0] reset_sync;

    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKIN1_PERIOD(5.000),
        .DIVCLK_DIVIDE(1),
        .CLKFBOUT_MULT_F(5.000),
        .CLKFBOUT_PHASE(0.000),
        .CLKOUT0_DIVIDE_F(20.000),
        .CLKOUT0_PHASE(0.000),
        .CLKOUT0_DUTY_CYCLE(0.500)
    ) sys_mmcm (
        .CLKIN1(board_clk_i),
        .CLKFBIN(clkfb_buf),
        .RST(reset_btn_i),
        .PWRDWN(1'b0),
        .CLKFBOUT(clkfb),
        .CLKFBOUTB(),
        .CLKOUT0(clk_50m_unbuf),
        .CLKOUT0B(),
        .CLKOUT1(),
        .CLKOUT1B(),
        .CLKOUT2(),
        .CLKOUT2B(),
        .CLKOUT3(),
        .CLKOUT3B(),
        .CLKOUT4(),
        .CLKOUT5(),
        .CLKOUT6(),
        .LOCKED(mmcm_locked)
    );

    BUFG clkfb_bufg (
        .I(clkfb),
        .O(clkfb_buf)
    );

    BUFG sys_clk_bufg (
        .I(clk_50m_unbuf),
        .O(sys_clk)
    );

    always @(posedge sys_clk or negedge mmcm_locked) begin
        if (!mmcm_locked)
            reset_sync <= 4'hf;
        else
            reset_sync <= {reset_sync[2:0], reset_btn_i};
    end

    vscpu3x_auto_tester_top #(
        .SYS_CLK_HZ(SYS_CLK_HZ),
        .MODBUS_BAUD(MODBUS_BAUD),
        .CUT_UART_BAUD(CUT_UART_BAUD)
    ) auto_tester_top_inst (
        .clk_i(sys_clk),
        .rst_i(|reset_sync),

        .modbus_uart_rx_i(modbus_uart_rx_i),
        .modbus_uart_tx_o(modbus_uart_tx_o),

        .cut_reset_o(cut_reset_o),
        .cut_program_sel_o(cut_program_sel_o),
        .cut_uart_rx_o(cut_uart_rx_o),
        .cut_uart_tx_i(cut_uart_tx_i),
        .cut_done_i(cut_done_i),
        .cut_gpio_in_o(cut_gpio_in_o),
        .cut_gpio_out_i(cut_gpio_out_i),

        .pinmux_enable_o(pinmux_enable_o)
    );

endmodule
