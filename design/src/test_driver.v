module test_driver #(
    parameter integer uart_clkdiv = 434,
    parameter integer gpio_half_period_cycles = 250000
) (
    input               i_clk,
    input               i_rst,

    input               i_functional_mode,
    input               i_test_active,
    input               i_test_start,
    output reg          o_test_done,

    input               i_uart_tx_rready,
    output reg          o_uart_tx_rvalid,
    input      [7:0]    i_uart_tx_rdata,

    input               i_uart_rx_wready,
    output reg          o_uart_rx_wvalid,
    output reg [7:0]    o_uart_rx_wdata,

    output reg          o_gpio_mismatch_incr,
    input      [7:0]    i_gpio_pattern_len,

    input               i_gpio_pattern_ready,
    output reg          o_gpio_pattern_ren,
    output reg [2:0]    o_gpio_pattern_wen,
    output reg [7:0]    o_gpio_pattern_addr,
    input      [10:0]   i_gpio_pattern_input_data,
    input      [10:0]   i_gpio_pattern_output_chk_data,
    output reg [10:0]   o_gpio_pattern_output_act_data,

    output reg [10:0]   o_vscpu3x_gpio_in,
    input      [10:0]   i_vscpu3x_gpio_out,

    input               i_rx,
    output              o_tx
);

    localparam TX_IDLE      = 2'd0;
    localparam TX_WAIT_DATA = 2'd1;

    localparam RX_IDLE      = 2'd0;
    localparam RX_WRITE     = 2'd1;

    localparam GPIO_IDLE    = 3'd0;
    localparam GPIO_REQ0    = 3'd1;
    localparam GPIO_LOAD0   = 3'd2;
    localparam GPIO_RUN     = 3'd3;
    localparam GPIO_REQNEXT = 3'd4;
    localparam GPIO_LOADNEXT= 3'd5;
    localparam GPIO_DONE    = 3'd6;
    localparam GPIO_WAIT    = 3'd7;

    reg        uart_tx_wren;
    reg [7:0]  uart_tx_data;
    wire       uart_tx_ready;
    wire       uart_rx_ready;
    reg        uart_rx_rden;
    wire [7:0] uart_rx_data;

    reg [1:0] tx_state;
    reg [1:0] rx_state;

    reg [2:0] gpio_state;
    reg [2:0] gpio_return_state;
    reg [31:0] gpio_half_counter;
    reg [7:0] edge_count;
    reg [7:0] next_read_index;
    reg [10:0] current_input;
    reg [10:0] current_check;
    reg [10:0] next_input;
    reg [10:0] next_check;
    reg [10:0] vscpu3x_gpio_out_meta;
    reg [10:0] vscpu3x_gpio_out_sync;
    reg        sync_low_mismatch_pending;

    wire [7:0] gpio_len = {1'b0, i_gpio_pattern_len[6:0]};
    wire       gpio_half_tick = (gpio_half_counter == 32'h0);
    wire       next_sync_level = ~o_vscpu3x_gpio_in[10];
    wire       high_sync_bad = (vscpu3x_gpio_out_sync[10] != 1'b0);
    wire       low_sync_bad = (vscpu3x_gpio_out_sync[10] != 1'b1);

    cmd_uart #(
        .clkdiv(uart_clkdiv)
    ) uart_bridge (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_enable(1'b1),

        .i_tx_data(uart_tx_data),
        .o_tx_ready(uart_tx_ready),
        .i_tx_wren(uart_tx_wren),

        .o_rx_data(uart_rx_data),
        .o_rx_ready(uart_rx_ready),
        .i_rx_rden(uart_rx_rden),
        .o_rx_fifo_overflow(),

        .i_rx(i_rx),
        .o_tx(o_tx)
    );

    always @(posedge i_clk) begin
        if (i_rst) begin
            vscpu3x_gpio_out_meta <= 11'h0;
            vscpu3x_gpio_out_sync <= 11'h0;
        end else begin
            vscpu3x_gpio_out_meta <= i_vscpu3x_gpio_out;
            vscpu3x_gpio_out_sync <= vscpu3x_gpio_out_meta;
        end
    end

    always @(posedge i_clk) begin
        if (i_rst || !i_functional_mode) begin
            tx_state          <= TX_IDLE;
            o_uart_tx_rvalid <= 1'b0;
            uart_tx_wren     <= 1'b0;
            uart_tx_data     <= 8'h00;
        end else begin
            o_uart_tx_rvalid <= 1'b0;
            uart_tx_wren     <= 1'b0;

            case (tx_state)
                TX_IDLE: begin
                    if (i_uart_tx_rready && uart_tx_ready) begin
                        o_uart_tx_rvalid <= 1'b1;
                        tx_state         <= TX_WAIT_DATA;
                    end
                end
                TX_WAIT_DATA: begin
                    if (uart_tx_ready) begin
                        uart_tx_data <= i_uart_tx_rdata;
                        uart_tx_wren <= 1'b1;
                        tx_state     <= TX_IDLE;
                    end
                end
                default: begin
                    tx_state <= TX_IDLE;
                end
            endcase
        end
    end

    always @(posedge i_clk) begin
        if (i_rst || !i_functional_mode) begin
            rx_state          <= RX_IDLE;
            uart_rx_rden      <= 1'b0;
            o_uart_rx_wvalid  <= 1'b0;
            o_uart_rx_wdata   <= 8'h00;
        end else begin
            uart_rx_rden     <= 1'b0;
            o_uart_rx_wvalid <= 1'b0;

            case (rx_state)
                RX_IDLE: begin
                    if (uart_rx_ready && i_uart_rx_wready) begin
                        uart_rx_rden <= 1'b1;
                        rx_state     <= RX_WRITE;
                    end
                end
                RX_WRITE: begin
                    if (i_uart_rx_wready) begin
                        o_uart_rx_wdata  <= uart_rx_data;
                        o_uart_rx_wvalid <= 1'b1;
                        rx_state         <= RX_IDLE;
                    end
                end
                default: begin
                    rx_state <= RX_IDLE;
                end
            endcase
        end
    end

    always @(posedge i_clk) begin
        if (i_rst) begin
            gpio_state                   <= GPIO_IDLE;
            gpio_return_state            <= GPIO_IDLE;
            gpio_half_counter            <= 32'h0;
            edge_count                   <= 8'h0;
            next_read_index              <= 8'h0;
            current_input                <= 11'h0;
            current_check                <= 11'h0;
            next_input                   <= 11'h0;
            next_check                   <= 11'h0;
            sync_low_mismatch_pending   <= 1'b0;
            o_test_done                  <= 1'b1;
            o_gpio_mismatch_incr         <= 1'b0;
            o_gpio_pattern_ren           <= 1'b0;
            o_gpio_pattern_wen           <= 3'b000;
            o_gpio_pattern_addr          <= 8'h0;
            o_gpio_pattern_output_act_data <= 11'h0;
            o_vscpu3x_gpio_in            <= 11'h0;
        end else begin
            o_gpio_mismatch_incr <= 1'b0;
            o_gpio_pattern_ren   <= 1'b0;
            o_gpio_pattern_wen   <= 3'b000;

            if (!i_test_active || !i_functional_mode) begin
                gpio_state                 <= GPIO_IDLE;
                gpio_half_counter          <= 32'h0;
                edge_count                 <= 8'h0;
                sync_low_mismatch_pending <= 1'b0;
                o_test_done                <= 1'b1;
                o_vscpu3x_gpio_in          <= 11'h0;
            end else begin
                case (gpio_state)
                    GPIO_IDLE: begin
                        o_test_done                <= (gpio_len == 8'h0);
                        edge_count                 <= 8'h0;
                        sync_low_mismatch_pending <= 1'b0;
                        o_vscpu3x_gpio_in          <= 11'h0;
                        if (i_test_start && (gpio_len != 8'h0))
                            gpio_state <= GPIO_REQ0;
                    end

                    GPIO_REQ0: begin
                        if (i_gpio_pattern_ready) begin
                            o_gpio_pattern_addr <= 8'h0;
                            o_gpio_pattern_ren  <= 1'b1;
                            gpio_return_state   <= GPIO_LOAD0;
                            gpio_state          <= GPIO_WAIT;
                        end
                    end

                    GPIO_WAIT: begin
                        gpio_state <= gpio_return_state;
                    end

                    GPIO_LOAD0: begin
                        current_input     <= i_gpio_pattern_input_data;
                        current_check     <= i_gpio_pattern_output_chk_data;
                        gpio_half_counter <= (gpio_half_period_cycles > 0) ?
                                             (gpio_half_period_cycles - 1) : 32'h0;
                        gpio_state        <= GPIO_RUN;
                    end

                    GPIO_RUN: begin
                        if (!gpio_half_tick) begin
                            gpio_half_counter <= gpio_half_counter - 1'b1;
                        end else begin
                            gpio_half_counter <= (gpio_half_period_cycles > 0) ?
                                                 (gpio_half_period_cycles - 1) : 32'h0;
                            o_vscpu3x_gpio_in[10] <= next_sync_level;

                            if (next_sync_level) begin
                                if (edge_count == 8'h0) begin
                                    o_vscpu3x_gpio_in[9:0] <= current_input[9:0];
                                    edge_count             <= 8'h1;
                                    if (gpio_len > 8'h1) begin
                                        next_read_index <= 8'h1;
                                        gpio_state      <= GPIO_REQNEXT;
                                    end
                                end else begin
                                    o_gpio_pattern_addr            <= edge_count - 1'b1;
                                    o_gpio_pattern_output_act_data <= vscpu3x_gpio_out_sync;
                                    o_gpio_pattern_wen             <= 3'b100;

                                    if (high_sync_bad ||
                                        sync_low_mismatch_pending ||
                                        (vscpu3x_gpio_out_sync[9:0] != current_check[9:0]))
                                        o_gpio_mismatch_incr <= 1'b1;

                                    sync_low_mismatch_pending <= 1'b0;

                                    if (edge_count == gpio_len) begin
                                        o_test_done <= 1'b1;
                                        gpio_state  <= GPIO_DONE;
                                    end else begin
                                        o_vscpu3x_gpio_in[9:0] <= next_input[9:0];
                                        current_input          <= next_input;
                                        current_check          <= next_check;
                                        edge_count             <= edge_count + 1'b1;
                                        if ((edge_count + 1'b1) < gpio_len) begin
                                            next_read_index <= edge_count + 1'b1;
                                            gpio_state      <= GPIO_REQNEXT;
                                        end
                                    end
                                end
                            end else begin
                                if (edge_count != 8'h0 && low_sync_bad)
                                    sync_low_mismatch_pending <= 1'b1;
                            end
                        end
                    end

                    GPIO_REQNEXT: begin
                        if (i_gpio_pattern_ready) begin
                            o_gpio_pattern_addr <= next_read_index;
                            o_gpio_pattern_ren  <= 1'b1;
                            gpio_return_state   <= GPIO_LOADNEXT;
                            gpio_state          <= GPIO_WAIT;
                        end
                    end

                    GPIO_LOADNEXT: begin
                        next_input <= i_gpio_pattern_input_data;
                        next_check <= i_gpio_pattern_output_chk_data;
                        gpio_state <= GPIO_RUN;
                    end

                    GPIO_DONE: begin
                        o_test_done <= 1'b1;
                    end

                    default: begin
                        gpio_state <= GPIO_IDLE;
                    end
                endcase
            end
        end
    end

endmodule
