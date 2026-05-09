module test_driver #(
    parameter uart_clkdiv = 868,
    parameter gpio_intval = 100000
) (
    input               i_clk,
    input               i_rst,

    input               i_a0_done,    
    input               i_ct_done,
    input               i_cm_done,

    output              o_test_running,
    output              o_a0_running,
    output              o_ct_running,
    output              o_cm_running,
        
    output              o_uart_tx_wready,
    input               i_uart_tx_wvalid,
    input      [7:0]    i_uart_tx_wdata,

    output              o_uart_rx_rready,
    input               i_uart_rx_rvalid,
    output     [7:0]    o_uart_rx_rdata,

    output reg          o_gpio_mismatch_incr,
    input      [7:0]    i_gpio_pattern_len,

    input               i_gpio_pattern_rready,
    output reg          o_gpio_pattern_rvalid,
    input      [10:0]   i_gpio_pattern_input_data,
    input      [10:0]   i_gpio_pattern_output_chk_data,

    input               i_gpio_pattern_wready,
    output reg          o_gpio_pattern_wvalid,
    output reg [10:0]   o_gpio_pattern_output_act_data,

    output reg [10:0]   o_vscpu3x_gpio_in,
    input      [10:0]   i_vscpu3x_gpio_out,

    input               i_rx,
    output              o_tx
);
    reg [31:0] gpio_intval_counter;
    reg [7:0] gpio_pattern_counter;

    reg [10:0] vscpu3x_gpio_out_sync1, vscpu3x_gpio_out_sync2;

    assign o_test_running   = o_a0_running | o_ct_running | o_cm_running;    
    assign o_a0_running     = ~i_a0_done;
    assign o_ct_running     = ~i_ct_done;
    assign o_cm_running     = ~i_cm_done;

    cmd_uart #(
        .clkdiv(uart_clkdiv)
    ) i_cmd_uart (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_enable(1'b1),
        
        .i_tx_data(i_uart_tx_wdata),
        .o_tx_ready(o_uart_tx_wready),
        .i_tx_wren(i_uart_tx_wvalid),

        .o_rx_data(o_uart_rx_rdata),
        .o_rx_ready(o_uart_rx_rready),
        .i_rx_rden(i_uart_rx_rvalid),
        .o_rx_fifo_overflow(),
        
        .i_rx(i_rx),
        .o_tx(o_tx)
    );

    // GPIO input synchronizer
    always @(posedge i_clk) begin
        if (i_rst) begin
            vscpu3x_gpio_out_sync1 <= 'h0;
            vscpu3x_gpio_out_sync2 <= 'h0;
        end else begin 
            vscpu3x_gpio_out_sync1 <= i_vscpu3x_gpio_out;
            vscpu3x_gpio_out_sync2 <= vscpu3x_gpio_out_sync1;
        end
    end

    // Update GPIO interval counter
    always @(posedge i_clk) begin
        if (i_rst) gpio_intval_counter <= gpio_intval;
        else if (!gpio_intval_counter) gpio_intval_counter <= gpio_intval;
        else gpio_intval_counter <= gpio_intval_counter - 1;
    end

    // Update GPIO pattern counter
    always @(posedge i_clk) begin
        if (i_rst) gpio_pattern_counter <= 8'h0;
        else if (!o_test_running) gpio_pattern_counter <= 8'h0;
        else if (!gpio_intval_counter && (gpio_pattern_counter < i_gpio_pattern_len)) gpio_pattern_counter <= gpio_pattern_counter + 1;
    end

            
    // Drive and check GPIO patterns
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_gpio_mismatch_incr            <= 1'b0;
            o_gpio_pattern_rvalid           <= 1'b0;
            o_gpio_pattern_wvalid           <= 1'b0;
            o_gpio_pattern_output_act_data  <= 'h0;
            
            o_vscpu3x_gpio_in   <= 'h0;
        end else begin
            o_gpio_mismatch_incr  <= 1'b0;
            o_gpio_pattern_rvalid <= 1'b0;
            o_gpio_pattern_wvalid <= 1'b0;

            if (gpio_pattern_counter < i_gpio_pattern_len) begin
                case (gpio_intval_counter)
                    gpio_intval: begin
                        if (i_gpio_pattern_rready) o_gpio_pattern_rvalid <= 1'b1;
                    end
                    gpio_intval - 1: begin
                        o_vscpu3x_gpio_in <= i_gpio_pattern_input_data;
                    end
                    32'h0: begin
                        if (i_gpio_pattern_wready) o_gpio_pattern_wvalid <= 1'b1;
                        o_gpio_pattern_output_act_data <= vscpu3x_gpio_out_sync2;

                        if (vscpu3x_gpio_out_sync2 != i_gpio_pattern_output_chk_data)
                            o_gpio_mismatch_incr <= o_gpio_mismatch_incr + 1;
                    end
                endcase
            end
        end
    end

endmodule