module vscpu3x_pinmux (
    input               i_clk,
    input               i_rst,

    input               i_set_pinmux_bp,

    input               i_tester_cut_reset,
    input       [1:0]   i_tester_program_sel,
    input               i_tester_uart_rx,
    input       [10:0]  i_tester_gpio_in,

    output              o_cut_reset,
    output      [1:0]   o_cut_program_sel,
    output              o_cut_uart_rx,
    output      [10:0]  o_cut_gpio_in,

    input               i_cut_uart_tx,
    input       [2:0]   i_cut_done,
    input       [10:0]  i_cut_gpio_out,

    output              o_tester_uart_tx,
    output      [2:0]   o_tester_done,
    output      [10:0]  o_tester_gpio_out,
    output              o_pinmux_enable
);

    reg [4:0] init_reset_counter;
    reg set_pinmux_bp_q1;

    assign o_pinmux_enable   = i_set_pinmux_bp;

    assign o_cut_reset       = (i_set_pinmux_bp) ? (init_reset_counter) ? init_reset_counter[4] : i_tester_cut_reset  : 1'b1;
    assign o_cut_program_sel = (i_set_pinmux_bp) ? i_tester_program_sel: 2'b11;
    assign o_cut_uart_rx     = (i_set_pinmux_bp) ? i_tester_uart_rx    : 1'b1;
    assign o_cut_gpio_in     = (i_set_pinmux_bp) ? i_tester_gpio_in    : 11'h7ff;

    assign o_tester_uart_tx  = (i_set_pinmux_bp) ? i_cut_uart_tx       : 1'b1;
    assign o_tester_done     = (i_set_pinmux_bp) ? i_cut_done          : 3'b111;
    assign o_tester_gpio_out = (i_set_pinmux_bp) ? i_cut_gpio_out      : 11'h7ff;

    // Following FF for rising edge detection of set_pinmux
    always @(posedge i_clk) set_pinmux_bp_q1 <= (i_rst) ? 1'b0 : i_set_pinmux_bp; 

    // Initial reset logic
    always @(posedge i_clk) begin
        if (i_rst) begin
            init_reset_counter <= 5'h00;
        end else begin
            if (init_reset_counter) // Count to zero if greater than 0
                init_reset_counter <= init_reset_counter - 1;

            if (~set_pinmux_bp_q1 & i_set_pinmux_bp)
                init_reset_counter <= 5'h1f;
        end
    end

endmodule
