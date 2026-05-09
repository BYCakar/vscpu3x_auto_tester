`include "defines.vh"

module cmd_uart_controller(
    input             clk_i,
	input             rstn_i,
    input             enable_i,

    input             start_i,
    input             wen_i,
    output reg        done_o,
    output            busy_o,
    output reg        err_o,
    input      [13:0] addr_i,
    output reg [31:0] rdata_o,
    input      [31:0] wdata_i,

    input             rx_i,
    output            tx_o
);

    `include "cmdlib.svh"

    localparam S_IDLE = 4'h0;
    localparam S_RD_READDATA = 4'h1;
    localparam S_RD_DATARCV = 4'h2;
    localparam S_RD_COMPARE = 4'h3;
    localparam S_WR_SETADDR = 4'h8;
    localparam S_WR_WRITEDATA = 4'h9;
    localparam S_WR_READBACK = 4'ha;
    localparam S_WR_DATARCV = 4'hb;
    localparam S_WR_COMPARE = 4'hc;

    localparam MAX_WR_RETRY = 3'h3;

    reg        uart_rx_rden;
    reg        uart_rx_rden_q1;
    reg        uart_tx_wren;
    reg  [7:0] uart_tx_data;
    wire       uart_tx_ready;
    wire       uart_rx_ready;
    wire       uart_rx_fifo_overflow;
    wire [7:0] uart_rx_data;

    reg  [0:7][7:0] buf_rddata [0:2];
    reg  [0:4][7:0] buf_rdcmd;
    reg  [0:8][7:0] buf_wrcmd;

    reg  [3:0] state;

    reg  [2:0] retry_count;
    reg  [3:0] data_count;

    assign busy_o = |state; // busy is 1 when state is not idle

    always @(posedge clk_i) begin
        if (!rstn_i) begin
            rdata_o     <= 32'h0;
            done_o      <= 1'b0;
            err_o       <= 1'b0;
             
            uart_rx_rden    <= 1'b0; 
            uart_rx_rden_q1 <= 1'b0;
            uart_tx_wren    <= 1'b0; 
            uart_tx_data    <= 7'h0;     
            
            retry_count <= 3'h0;
            data_count  <= 4'h0;

            buf_rddata[0] <= 'h0;
            buf_rddata[1] <= 'h0;
            buf_rddata[2] <= 'h0;
            buf_rdcmd     <= 'h0;
            buf_wrcmd     <= 'h0;

            state <= S_IDLE;
        end 
        else if (enable_i) begin
            done_o <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (start_i) begin
                        buf_rdcmd <= to_rdcmd(addr_i);
                        buf_wrcmd <= to_wrcmd(wdata_i);
                        state <= (wen_i) ? S_WR_SETADDR : S_RD_READDATA;
                    end
                end

                S_RD_READDATA,
                S_WR_SETADDR,
                S_WR_READBACK: begin
                    uart_tx_wren <= 1'b0;

                    if (uart_tx_ready) begin
                        uart_tx_data <= buf_rdcmd[data_count];
                        uart_tx_wren <= 1'b1;

                        if (data_count == 4'h4) begin
                            data_count <= 4'h0;

                            case (state)
                                S_RD_READDATA : state <= S_RD_DATARCV;
                                S_WR_SETADDR : state <= S_WR_WRITEDATA;
                                S_WR_READBACK : state <= S_WR_COMPARE;
                            endcase
                        end
                        else
                            data_count <= data_count + 1;
                    end
                end

                S_RD_DATARCV: begin
                    uart_rx_rden <= uart_rx_ready; // If UART_RX is ready, read it
                    uart_rx_rden_q1 <= uart_rx_rden;

                    if (uart_rx_rden_q1) begin
                        buf_rddata[retry_count][data_count[2:0]] <= uart_rx_data;
                        data_count[2:0] <= data_count + 1; // Always true because data_count + 1 will be 0 when it is 15
                    
                        if (&data_count[2:0]) begin
                            state <= (retry_count) ? S_RD_COMPARE : S_RD_READDATA; // If data_count == 8, go on to the next state 
                            retry_count <= retry_count + 1;
                        end
                    end
                end

                S_RD_COMPARE: begin
                    if (retry_count == 3'h2) begin // Double check read data
                        if (buf_rddata[0] == buf_rddata[1]) begin
                            rdata_o <= to_rdata(buf_rddata[0]);

                            retry_count <= 3'h0;

                            err_o <= 1'b0;
                            done_o <= 1'b1;
                            state <= S_IDLE;
                        end
                        else state <= S_RD_READDATA;
                    end
                    else if (retry_count == 3'h3) begin // Return same 2 pair, if there is no pair return an error
                        err_o <= 1'b0;
                        
                        if (buf_rddata[0] == buf_rddata[2]) 
                            rdata_o <= to_rdata(buf_rddata[0]);
                        else if (buf_rddata[1] == buf_rddata[2]) 
                            rdata_o <= to_rdata(buf_rddata[1]);
                        else 
                            err_o <= 1'b1;

                        retry_count <= 3'h0;

                        done_o <= 1'b1;
                        state <= S_IDLE;
                    end
                end

                S_WR_WRITEDATA: begin
                    uart_tx_wren <= 1'b0;

                    if (uart_tx_ready) begin
                        uart_tx_data <= buf_wrcmd[data_count];
                        uart_tx_wren <= 1'b1;

                        if (data_count == 4'h8) begin
                            data_count <= 4'h0;

                            buf_rdcmd <= to_rdcmd(addr_i);
                            state <= S_WR_READBACK;
                        end
                        else
                            data_count <= data_count + 1;
                    end
                end

                S_WR_DATARCV: begin
                    uart_rx_rden <= uart_rx_ready; // If UART_RX is ready, read it
                    uart_rx_rden_q1 <= uart_rx_rden;

                    if (uart_rx_rden_q1) begin
                        buf_rddata[data_count[3]][data_count[2:0]] <= uart_rx_data;
                        data_count <= data_count + 1; // Always true because data_count + 1 will be 0 when it is 15
                    
                        if (&data_count) state <= S_WR_COMPARE; // If data_count == 15, go on to the next state 
                    end
                end

                S_WR_COMPARE: begin
                    if (wdata_i == to_rdata(buf_rddata[0])) begin
                        retry_count <= 3'h0;

                        err_o <= 1'b0;
                        done_o <= 1'b1;
                        state <= S_IDLE;
                    end
                    else if (retry_count < MAX_WR_RETRY) begin
                        retry_count <= retry_count + 1;
                        state <= S_WR_WRITEDATA;
                    end
                    else begin
                        retry_count <= 3'h0;

                        err_o <= 1'b1;
                        done_o <= 1'b1;
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end

    cmd_uart #(.fifo_w(5)) uart_inst
    (
        .i_clk(clk_i),
        .i_rst(~rstn_i),
        .i_enable(1'b1),

        .i_tx_data(uart_tx_data),
        .o_tx_ready(uart_tx_ready),
        .i_tx_wren(uart_tx_wren),

        .o_rx_data(uart_rx_data),
        .o_rx_ready(uart_rx_ready),
        .i_rx_rden(uart_rx_rden),
        .o_rx_fifo_overflow(uart_rx_fifo_overflow),

        .i_rx(rx_i),
        .o_tx(tx_o)
    );

endmodule
