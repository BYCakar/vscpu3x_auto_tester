
module cmd_uart #(
    parameter   clkdiv = 868, // Assumed 100 MHz clock frequency
    parameter   fifo_w = 4
    )
    (
    // Clock, reset and enable pins
    input       i_clk,
    input       i_rst,
    input       i_enable,
    // Interface with command module
    input       [7:0] i_tx_data,
    output      o_tx_ready,
    input       i_tx_wren,

    output      [7:0] o_rx_data,
    output      o_rx_ready,
    input       i_rx_rden,
    output      o_rx_fifo_overflow,
    // UART interface
    input       i_rx,
    output      o_tx
    );

    // UART RX signals
    wire        uart_rx_dv;
    wire [7:0]  uart_rx_byte;

    // UART TX signals
    reg         uart_tx_dv;
    wire [7:0]  uart_tx_byte;
    wire        uart_tx_active;

    // RX FIFO signals
    wire        rx_fifo_empty;
    wire        rx_fifo_full;
    wire        rx_fifo_err;
    
    // TX FIFO signals
    wire        tx_fifo_empty;
    wire        tx_fifo_full;
    wire        tx_fifo_rden;

    modbus_fifo #(.ADDR_W(fifo_w), .BUFF_L(2**fifo_w)) rx_fifo(
		.clk(i_clk),
		.n_reset(~i_rst),
		.wr_en(uart_rx_dv),
		.data_in(uart_rx_byte),
		.rd_en(i_rx_rden),

		.data_out(o_rx_data),
		.data_count(),
		.empty(rx_fifo_empty),
		.full(rx_fifo_full),
		.almst_empty(),
		.almst_full(),
		.err(rx_fifo_err)
	);

    modbus_fifo #(.ADDR_W(fifo_w), .BUFF_L(2**fifo_w)) tx_fifo(
		.clk(i_clk),
		.n_reset(~i_rst),
		.wr_en(i_tx_wren),
		.data_in(i_tx_data),
		.rd_en(tx_fifo_rden),

		.data_out(uart_tx_byte),
		.data_count(),
		.empty(tx_fifo_empty),
		.full(tx_fifo_full),
		.almst_empty(),
		.almst_full(),
		.err()
	);

    // UART RX instantiation
    modbus_uart_rx #(clkdiv) uart_rx_inst(
        .i_Clock(i_clk),
        .i_Rx_Serial(i_rx),
        .o_Rx_DV(uart_rx_dv),
        .o_Rx_Byte(uart_rx_byte)
        );

    // UART TX instantiation
    modbus_uart_tx #(clkdiv) uart_tx_inst(
        .i_Clock(i_clk),
        .i_Tx_DV(uart_tx_dv),
        .i_Tx_Byte(uart_tx_byte),
        .o_Tx_Active(uart_tx_active),
        .o_Tx_Serial(o_tx),
        .o_Tx_Done()
        );

    assign o_rx_ready = ~rx_fifo_empty;
    assign o_rx_fifo_overflow = rx_fifo_full & rx_fifo_err;

    assign o_tx_ready = ~tx_fifo_full;
    assign tx_fifo_rden = ~tx_fifo_empty & ~uart_tx_active & ~uart_tx_dv;

    always @(posedge i_clk) uart_tx_dv <= (i_rst) ? 1'b0 : tx_fifo_rden;

endmodule
