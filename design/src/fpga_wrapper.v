module fpga_wrapper #(
    parameter integer BOARD_CLK_HZ = 200000000,
    parameter integer SYS_CLK_HZ    = 50000000,
    parameter integer MODBUS_BAUD   = 115200,
    parameter integer CUT_UART_BAUD = 57600
) (
    input               sysclk_p_i,
    input               sysclk_n_i,
    input               cpu_resetn_i,

    input               modbus_uart_rx_i,
    output              modbus_uart_tx_o,

    inout       [37:8]  vscpu3x_io
);

    localparam real MMCM_CLKFB_MULT_F = 5.000;
    localparam real BOARD_CLK_PERIOD_NS = 1000000000.0 / BOARD_CLK_HZ;
    localparam real MMCM_CLKOUT0_DIVIDE_F =
        (BOARD_CLK_HZ * MMCM_CLKFB_MULT_F) / SYS_CLK_HZ;

    wire board_clk;
    wire board_resetn;
    wire board_reset;
    wire modbus_uart_rx;
    wire modbus_uart_tx;

    wire clkfb;
    wire clkfb_buf;
    wire clk_50m_unbuf;
    wire sys_clk;
    wire mmcm_locked;

    wire        cut_reset;
    wire [1:0]  cut_program_sel;
    wire        cut_uart_rx;
    wire [10:0] cut_gpio_in;
    wire        pinmux_enable;
    wire        pad_drive_enable;

    wire [37:8] vscpu3x_io_i;
    wire [37:8] vscpu3x_io_o;
    wire [37:8] vscpu3x_io_t;

    reg [3:0] reset_sync;

    IBUFDS #(
        .DIFF_TERM("FALSE"),
        .IBUF_LOW_PWR("TRUE"),
        .IOSTANDARD("LVDS")
    ) sysclk_ibufds (
        .I(sysclk_p_i),
        .IB(sysclk_n_i),
        .O(board_clk)
    );

    IBUF #(
        .IBUF_LOW_PWR("TRUE"),
        .IOSTANDARD("LVCMOS33")
    ) cpu_resetn_ibuf (
        .I(cpu_resetn_i),
        .O(board_resetn)
    );

    IBUF #(
        .IBUF_LOW_PWR("TRUE"),
        .IOSTANDARD("LVCMOS33")
    ) modbus_uart_rx_ibuf (
        .I(modbus_uart_rx_i),
        .O(modbus_uart_rx)
    );

    OBUF #(
        .DRIVE(8),
        .IOSTANDARD("LVCMOS33"),
        .SLEW("SLOW")
    ) modbus_uart_tx_obuf (
        .I(modbus_uart_tx),
        .O(modbus_uart_tx_o)
    );

    assign board_reset = ~board_resetn;

    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKIN1_PERIOD(BOARD_CLK_PERIOD_NS),
        .DIVCLK_DIVIDE(1),
        .CLKFBOUT_MULT_F(MMCM_CLKFB_MULT_F),
        .CLKFBOUT_PHASE(0.000),
        .CLKOUT0_DIVIDE_F(MMCM_CLKOUT0_DIVIDE_F),
        .CLKOUT0_PHASE(0.000),
        .CLKOUT0_DUTY_CYCLE(0.500)
    ) sys_mmcm (
        .CLKIN1(board_clk),
        .CLKFBIN(clkfb_buf),
        .RST(board_reset),
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
            reset_sync <= {reset_sync[2:0], board_reset};
    end

    // VSCPU3x package pins 8..37 are placed on JA, JB, JC, and JD in
    // their native order. IOBUF.T is active high: tester-driven CUT inputs
    // are released whenever the pinmux is disabled or the wrapper is in
    // reset, while CUT outputs are always inputs at the FPGA.
    assign pad_drive_enable =
        pinmux_enable && mmcm_locked && !(|reset_sync) && !board_reset;

    assign vscpu3x_io_o = {
        11'h000,
        cut_gpio_in,
        4'h0,
        cut_uart_rx,
        cut_program_sel,
        cut_reset
    };

    assign vscpu3x_io_t = {
        11'h7ff,
        {11{~pad_drive_enable}},
        4'hf,
        {4{~pad_drive_enable}}
    };

    genvar io_index;
    generate
        for (io_index = 8; io_index <= 37; io_index = io_index + 1) begin : gen_vscpu3x_iobuf
            IOBUF #(
                .DRIVE(8),
                .IBUF_LOW_PWR("TRUE"),
                .IOSTANDARD("LVCMOS33"),
                .SLEW("SLOW")
            ) vscpu3x_iobuf (
                .I(vscpu3x_io_o[io_index]),
                .O(vscpu3x_io_i[io_index]),
                .T(vscpu3x_io_t[io_index]),
                .IO(vscpu3x_io[io_index])
            );
        end
    endgenerate

    vscpu3x_auto_tester_top #(
        .SYS_CLK_HZ(SYS_CLK_HZ),
        .MODBUS_BAUD(MODBUS_BAUD),
        .CUT_UART_BAUD(CUT_UART_BAUD)
    ) auto_tester_top_inst (
        .clk_i(sys_clk),
        .rst_i(|reset_sync),

        .modbus_uart_rx_i(modbus_uart_rx),
        .modbus_uart_tx_o(modbus_uart_tx),

        .cut_reset_o(cut_reset),
        .cut_program_sel_o(cut_program_sel),
        .cut_uart_rx_o(cut_uart_rx),
        .cut_uart_tx_i(vscpu3x_io_i[12]),
        .cut_done_i(vscpu3x_io_i[15:13]),
        .cut_gpio_in_o(cut_gpio_in),
        .cut_gpio_out_i(vscpu3x_io_i[37:27]),

        .pinmux_enable_o(pinmux_enable)
    );

endmodule
