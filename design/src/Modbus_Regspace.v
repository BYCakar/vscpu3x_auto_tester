`include "Modbus_Regspace_defines.vh"

module Modbus_Regspace 
    (
        // Clock, reset and enable pins
	    input               i_clk,
        input               i_rst,

        // Interface with modbus controller
        input       [15:0]  i_modbus_addr,
        input               i_modbus_wren,
        input               i_modbus_rden,
        output reg  [15:0]  o_modbus_dout,
        input       [15:0]  i_modbus_din,
        output              o_modbus_wrready,

        // Interface with test controller
        // Command signals
        output reg          o_set_pinmux,
        output reg          o_fetch_actmem,
        output reg          o_fetch_progmem,
        output reg          o_force_stop,
        output reg          o_test_load_run,
        output reg          o_test_fast_run,

        // Status signals
        input               i_progmem_loading,
        input               i_actmem_fetching,
        input               i_progmem_fetching,
        input               i_test_running,
        input               i_a0_running,
        input               i_ct_running,
        input               i_cm_running,
        input               i_progmode,

        // Error signals
        input               i_program_error,
        input               i_memrw_error,
        output reg          o_program_error_clr,
        
        // Test num
        output reg  [3:0]   o_testnum,
        
        // UART buffer access signals
        output              o_uart_tx_rready,
        input               i_uart_tx_rvalid,
        output reg  [7:0]   o_uart_tx_rdata,

        output              o_uart_rx_wready,
        input               i_uart_rx_wvalid,
        input       [7:0]   i_uart_rx_wdata,

        // GPIO pattern buffer access signals
        input               i_gpio_mismatch_incr,
        input               i_gpio_mismatch_clr,

        input               i_gpio_pattern_len_update,
        input       [7:0]   i_gpio_pattern_len,
        output reg  [7:0]   o_gpio_pattern_len,

        output reg          o_gpio_pattern_ready,
        input               i_gpio_pattern_ren,
        input       [2:0]   i_gpio_pattern_wen,
        input       [7:0]   i_gpio_pattern_addr,

        input       [10:0]  i_gpio_pattern_input_data,
        input       [10:0]  i_gpio_pattern_output_chk_data,
        input       [10:0]  i_gpio_pattern_output_act_data,

        output reg  [10:0]  o_gpio_pattern_input_data,
        output reg  [10:0]  o_gpio_pattern_output_chk_data,

        // PROGMEM access signals
        output reg  [11:0]  o_cm_proglen,
        output reg  [11:0]  o_ct_proglen,
        output reg  [10:0]  o_a0_proglen,
        input               i_proglen_update,
        input       [11:0]  i_cm_proglen_update_data,
        input       [11:0]  i_ct_proglen_update_data,
        input       [10:0]  i_a0_proglen_update_data,

        output reg          o_progmem_ready,
        input               i_progmem_valid,
        input               i_progmem_wen,
        input       [1:0]   i_progmem_sel,
        input       [11:0]  i_progmem_addr,
        input       [31:0]  i_progmem_wdata,
        output reg  [31:0]  o_progmem_rdata,

        // CHKMEM access signals
        input               i_chkmem_mismatch_clr,
        input               i_chkmem_cm_mismatch_incr,
        input               i_chkmem_ct_mismatch_incr,
        input               i_chkmem_a0_mismatch_incr,
        input               i_chkmem_shd_mismatch_incr,

        output reg          o_chkmem_ready,
        input               i_chkmem_valid,
        input               i_chkmem_wen,
        input       [1:0]   i_chkmem_sel,
        input       [11:0]  i_chkmem_addr,
        input       [31:0]  i_chkmem_wdata,
        output reg  [31:0]  o_chkmem_rdata,
        
        // ACTMEM access signals
        output reg          o_actmem_ready,
        input               i_actmem_valid,
        input       [1:0]   i_actmem_sel,
        input       [11:0]  i_actmem_addr,
        input       [31:0]  i_actmem_wdata,
        
        // MEMRW access signals
        input               i_memrw_ready,
        output reg          o_memrw_valid,
        output reg          o_memrw_wen,
        output reg  [1:0]   o_memrw_sel,  
        output reg  [11:0]  o_memrw_addr,
        output reg  [31:0]  o_memrw_wdata,
        input       [31:0]  i_memrw_rdata,

        // Soft reset signal
        output reg          o_soft_reset
    );

    // Control space
    reg  [15:0] cmd_reg;
    reg  [15:0] status_reg;
    reg  [15:0] error_reg;
    wire [15:0] test_num_reg;
    wire [15:0] uart_tx_prod_reg;
    wire [15:0] uart_tx_cons_reg;
    wire [15:0] uart_rx_prod_reg;
    wire [15:0] uart_rx_cons_reg;
    reg  [15:0] gpio_pattern_reg;
    wire [15:0] prog_cm_proglen_reg;
    wire [15:0] prog_ct_proglen_reg;
    wire [15:0] prog_a0_proglen_reg;
    reg  [15:0] memrw_datalo_reg;
    reg  [15:0] memrw_datahi_reg;
    reg  [15:0] memrw_addr_reg;
    wire [15:0] soft_reset_reg;

    // UART space
    reg  [15:0] uart_tx_buffer [0:2**(`UART_TX_PROD_BW-2)-1];
    reg  [15:0] uart_rx_buffer [0:2**(`UART_RX_PROD_BW-2)-1];
    
    // GPIO space
    reg  [15:0] gpio_input_buffer [0:2**(`GPIO_PATTERN_LEN_BW)-1];
    reg  [15:0] gpio_output_chk_buffer [0:2**(`GPIO_PATTERN_LEN_BW)-1];
    reg  [15:0] gpio_output_act_buffer [0:2**(`GPIO_PATTERN_LEN_BW)-1];

    // PROGMEM space
    reg  [31:0] progmem_cm [0:2047];
    reg  [31:0] progmem_ct [0:2559];
    reg  [31:0] progmem_a0 [0:1535];
    reg  [31:0] progmem_shd [0:63];
    reg  [31:0] progmem_shd_mask [0:1];

    // CHKMEM space
    reg  [31:0] chkmem_cm [0:2047];
    reg  [31:0] chkmem_ct [0:2559];
    reg  [31:0] chkmem_a0 [0:1535];
    reg  [31:0] chkmem_shd [0:63];
    reg  [31:0] chkmem_cm_mask [0:63];
    reg  [31:0] chkmem_ct_mask [0:79];
    reg  [31:0] chkmem_a0_mask [0:47];
    reg  [31:0] chkmem_shd_mask [0:1];

    // ACTMEM space
    reg  [31:0] actmem_cm [0:2047];
    reg  [31:0] actmem_ct [0:2559];
    reg  [31:0] actmem_a0 [0:1535];
    reg  [31:0] actmem_shd [0:63];
    
    reg  [15:0] chkmem_cm_mismatch_reg;
    reg  [15:0] chkmem_ct_mismatch_reg;
    reg  [15:0] chkmem_a0_mismatch_reg;
    reg  [15:0] chkmem_shd_mismatch_reg;
    
    // Status signals
    wire        error_flag;
    reg         memrw_done;
    wire        uart_rx_newdata;
    wire        uart_tx_newdata;
    reg         test_done;
    
    // Error signals
    reg         memrw_error;
    wire        uart_rx_overflow;
    wire        uart_tx_overflow;
    wire        gpio_mismatch;
    wire        shd_chk_mismatch;
    wire        a0_chk_mismatch;
    wire        ct_chk_mismatch;
    wire        cm_chk_mismatch;

    // UART buffer signals
    reg  [`UART_TX_PROD_BW-1:0] uart_tx_prod;
    reg  [`UART_TX_CONS_BW-1:0] uart_tx_cons;
    
    reg  [`UART_RX_PROD_BW-1:0] uart_rx_prod;
    reg  [`UART_RX_CONS_BW-1:0] uart_rx_cons;

    reg  [15:0]                 uart_tx_buffer_rdata;
    reg  [15:0]                 uart_rx_buffer_rdata;
    
    // GPIO pattern signals
    reg  [`GPIO_MISMATCH_COUNT_BW-1:0]  gpio_mismatch_count;

    reg  [15:0]                         gpio_input_buffer_rdata;
    reg  [15:0]                         gpio_output_chk_buffer_rdata;
    reg  [15:0]                         gpio_output_act_buffer_rdata;

    // ACTMEM rdata signal
    reg  [31:0]  actmem_rdata;

    // Misc signals
    reg  [15:0]  modbus_addr_q1;
    reg          memrw_ready_q1;
    reg          test_running_q1;

    assign o_modbus_wrready = 1'b1;

    // Modbus read process
    always @(posedge i_clk) modbus_addr_q1 <= (i_rst | ~i_modbus_rden) ? 16'h0 : i_modbus_addr;
    
    always @* begin
        if (i_rst)
            o_modbus_dout    = 'h0;  
        else begin
            o_modbus_dout    = 'h0;

            casez (modbus_addr_q1)
                `CMD_REG: 
                    o_modbus_dout = cmd_reg;
                `STATUS_REG:
                    o_modbus_dout = status_reg;
                `ERROR_REG: 
                    o_modbus_dout = error_reg;
                `TEST_NUM_REG: 
                    o_modbus_dout = test_num_reg;
                `UART_TX_PROD_REG: 
                    o_modbus_dout = uart_tx_prod_reg;
                `UART_TX_CONS_REG: 
                    o_modbus_dout = uart_tx_cons_reg;
                `UART_RX_PROD_REG: 
                    o_modbus_dout = uart_rx_prod_reg;
                `UART_RX_CONS_REG: 
                    o_modbus_dout = uart_rx_cons_reg;
                `GPIO_PATTERN_REG: 
                    o_modbus_dout = gpio_pattern_reg;
                `PROG_CM_PROGLEN_REG: 
                    o_modbus_dout = prog_cm_proglen_reg;
                `PROG_CT_PROGLEN_REG: 
                    o_modbus_dout = prog_ct_proglen_reg;
                `PROG_A0_PROGLEN_REG: 
                    o_modbus_dout = prog_a0_proglen_reg;
                `MEMRW_DATALO_REG: 
                    o_modbus_dout = memrw_datalo_reg;
                `MEMRW_DATAHI_REG: 
                    o_modbus_dout = memrw_datahi_reg;
                `MEMRW_ADDR_REG: 
                    o_modbus_dout = memrw_addr_reg;
                `SOFT_RESET_REG: 
                    o_modbus_dout = soft_reset_reg;
                `UART_TX_BUFFER: 
                    o_modbus_dout = uart_tx_buffer_rdata;
                `UART_RX_BUFFER: 
                    o_modbus_dout = uart_rx_buffer_rdata;
                `GPIO_INPUT_BUFFER: 
                    o_modbus_dout = gpio_input_buffer_rdata;
                `GPIO_OUTPUT_CHK_BUFFER: 
                    o_modbus_dout = gpio_output_chk_buffer_rdata;
                `GPIO_OUTPUT_ACT_BUFFER: 
                    o_modbus_dout = gpio_output_act_buffer_rdata;
                `PROGMEM_CM,
                `PROGMEM_CT,
                `PROGMEM_A0,
                `PROGMEM_SHD,
                `PROGMEM_SHD_MASK:  
                    o_modbus_dout = (modbus_addr_q1[0]) ? o_progmem_rdata[15:0] : o_progmem_rdata[31:16];
                `CHKMEM_CM,
                `CHKMEM_CT,
                `CHKMEM_A0,
                `CHKMEM_SHD,
                `CHKMEM_CM_MASK,
                `CHKMEM_CT_MASK,
                `CHKMEM_A0_MASK,
                `CHKMEM_SHD_MASK:
                    o_modbus_dout = (modbus_addr_q1[0]) ? o_chkmem_rdata[15:0] : o_chkmem_rdata[31:16];
                `ACTMEM_CM,
                `ACTMEM_CT,
                `ACTMEM_A0,
                `ACTMEM_SHD: 
                    o_modbus_dout = (modbus_addr_q1[0]) ? actmem_rdata[15:0] : actmem_rdata[31:16];
                `CHKMEM_CM_MISMATCH_REG: 
                    o_modbus_dout = chkmem_cm_mismatch_reg;
                `CHKMEM_CT_MISMATCH_REG: 
                    o_modbus_dout = chkmem_ct_mismatch_reg;
                `CHKMEM_A0_MISMATCH_REG: 
                    o_modbus_dout = chkmem_a0_mismatch_reg;
                `CHKMEM_SHD_MISMATCH_REG: 
                    o_modbus_dout = chkmem_shd_mismatch_reg;
            endcase
        end
    end  

    // Command reg assignment
    always @* begin
        cmd_reg = 16'h0;

        // SET_PINMUX is readable RW1T state. The other command fields are WO
        // one-cycle pulses and therefore read as zero.
        cmd_reg[`SET_PINMUX_BP] = o_set_pinmux;
    end
    
    // Command reg process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_set_pinmux    <= 1'b0;
            o_fetch_actmem  <= 1'b0;
            o_fetch_progmem <= 1'b0;
            o_force_stop    <= 1'b0;
            o_test_load_run <= 1'b0;
            o_test_fast_run <= 1'b0;
        end else begin
            o_fetch_actmem  <= 1'b0;
            o_fetch_progmem <= 1'b0;
            o_force_stop    <= 1'b0;
            o_test_load_run <= 1'b0;
            o_test_fast_run <= 1'b0;

            if (i_modbus_wren && (i_modbus_addr == `CMD_REG)) begin
                o_set_pinmux    <= i_modbus_din[`SET_PINMUX_BP] ^ o_set_pinmux;
                o_fetch_actmem  <= i_modbus_din[`FETCH_ACTMEM_BP];
                o_fetch_progmem <= i_modbus_din[`FETCH_PROGMEM_BP];
                o_force_stop    <= i_modbus_din[`FORCE_STOP_BP];
                o_test_load_run <= i_modbus_din[`TEST_LOAD_RUN_BP];
                o_test_fast_run <= i_modbus_din[`TEST_FAST_RUN_BP];
            end
        end
    end      
    
    // Status reg assignment
    always @* begin
        status_reg = 16'h0;

        status_reg[`ERROR_FLAG_BP]       = error_flag;   
        status_reg[`MEMRW_DONE_BP]       = memrw_done;   
        status_reg[`UART_RX_NEWDATA_BP]  = uart_rx_newdata;       
        status_reg[`UART_TX_NEWDATA_BP]  = uart_tx_newdata;       
        status_reg[`A0_RUNNING_BP]       = i_a0_running;   
        status_reg[`CT_RUNNING_BP]       = i_ct_running;   
        status_reg[`CM_RUNNING_BP]       = i_cm_running; 
        status_reg[`TEST_DONE_BP]        = test_done; 
        status_reg[`TEST_RUNNING_BP]     = i_test_running;         
        status_reg[`PROGMEM_LOADING_BP]  = i_progmem_loading;       
        status_reg[`ACTMEM_FETCHING_BP]  = i_actmem_fetching;       
        status_reg[`PROGMEM_FETCHING_BP] = i_progmem_fetching;           
        status_reg[`PROGMODE_BP]         = i_progmode;   
    end

    assign error_flag = |error_reg;

    assign uart_rx_newdata = (uart_rx_prod_reg == uart_rx_cons_reg) ? 1'b0 : 1'b1;

    assign uart_tx_newdata = (uart_tx_prod_reg == uart_tx_cons_reg) ? 1'b0 : 1'b1;

    // memrw_done update process
    always @(posedge i_clk) memrw_ready_q1 <= (i_rst) ? 1'b0 : i_memrw_ready;

    always @(posedge i_clk) begin 
        if (i_rst) memrw_done <= 1'b0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `STATUS_REG)) memrw_done <= (i_modbus_din[`MEMRW_DONE_BP]) ? 1'b0 : memrw_done;
            if (i_memrw_ready & ~memrw_ready_q1) memrw_done <= 1'b1;
        end
    end

    // test_done update process
    always @(posedge i_clk) test_running_q1 <= (i_rst) ? 1'b0 : i_test_running;

    always @(posedge i_clk) begin 
        if (i_rst) test_done <= 1'b0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `STATUS_REG)) test_done <= (i_modbus_din[`TEST_DONE_BP]) ? 1'b0 : test_done;
            if (~i_test_running & test_running_q1) test_done <= 1'b1;
        end
    end

    // Error reg assignment
    always @* begin
        error_reg = 16'h0;

        error_reg[`MEMRW_ERROR_BP]      = memrw_error;   
        error_reg[`UART_RX_OVERFLOW_BP] = uart_rx_overflow;       
        error_reg[`UART_TX_OVERFLOW_BP] = uart_tx_overflow;       
        error_reg[`PROGRAM_ERROR_BP]    = i_program_error;   
        error_reg[`GPIO_MISMATCH_BP]    = gpio_mismatch;       
        error_reg[`SHD_CHK_MISMATCH_BP] = shd_chk_mismatch;       
        error_reg[`A0_CHK_MISMATCH_BP]  = a0_chk_mismatch;           
        error_reg[`CT_CHK_MISMATCH_BP]  = ct_chk_mismatch;   
        error_reg[`CM_CHK_MISMATCH_BP]  = cm_chk_mismatch;  
    end

    // memrw_error update process
    always @(posedge i_clk) begin
        if (i_rst) memrw_error <= 1'b0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `ERROR_REG)) memrw_error <= (i_modbus_din[`MEMRW_ERROR_BP]) ? 1'b0 : memrw_error;
            if (i_memrw_error) memrw_error <= 1'b1;
        end
    end

    // program_error update process
    always @(posedge i_clk) begin 
        if (i_rst) o_program_error_clr <= 1'b0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `ERROR_REG)) o_program_error_clr <= i_modbus_din[`PROGRAM_ERROR_BP];
            else o_program_error_clr <= 1'b0;
        end
    end

    assign uart_rx_overflow = (uart_rx_prod_reg[`UART_RX_PROD_BW-2:0] == uart_rx_cons_reg[`UART_RX_CONS_BW-2:0]) && (uart_rx_prod_reg[`UART_RX_PROD_BW-1] ^ uart_rx_cons_reg[`UART_RX_CONS_BW-1]);
    assign uart_tx_overflow = (uart_tx_prod_reg[`UART_TX_PROD_BW-2:0] == uart_tx_cons_reg[`UART_TX_CONS_BW-2:0]) && (uart_tx_prod_reg[`UART_TX_PROD_BW-1] ^ uart_tx_cons_reg[`UART_TX_CONS_BW-1]);
    assign gpio_mismatch    = |gpio_mismatch_count;
    assign shd_chk_mismatch = |chkmem_shd_mismatch_reg;
    assign a0_chk_mismatch  = |chkmem_a0_mismatch_reg;
    assign ct_chk_mismatch  = |chkmem_ct_mismatch_reg;
    assign cm_chk_mismatch  = |chkmem_cm_mismatch_reg;

    // Test num reg assignment
    assign test_num_reg = o_testnum;   

    // o_testnum update process
    always @(posedge i_clk) begin
        if (i_rst) 
            o_testnum <= 'h0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `TEST_NUM_REG))
                o_testnum <= i_modbus_din[`TESTNUM_MSB_BP:`TESTNUM_LSB_BP];
        end
    end      

    // UART TX prod reg assignment
    assign uart_tx_prod_reg = uart_tx_prod;   

    // uart_tx_prod update process
    always @(posedge i_clk) begin
        if (i_rst) uart_tx_prod <= 'h0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `UART_TX_PROD_REG))
                uart_tx_prod <= i_modbus_din[`UART_TX_PROD_MSB_BP:`UART_TX_PROD_LSB_BP];
        end
    end

    // UART TX cons reg assignment
    assign uart_tx_cons_reg = uart_tx_cons; 

    // uart_tx_cons update process
    always @(posedge i_clk) begin
        if (i_rst) begin
            uart_tx_cons    <= 'h0;
            o_uart_tx_rdata <= 8'h0;
        end else begin
            if (i_uart_tx_rvalid & o_uart_tx_rready) begin
                uart_tx_cons    <= uart_tx_cons + 1;
                o_uart_tx_rdata <= uart_tx_buffer[uart_tx_cons[`UART_TX_CONS_BW-2:1]][((uart_tx_cons[0])?0:8)+:8];
            end
        end
    end

    assign o_uart_tx_rready = uart_tx_newdata & ~i_progmode; // Read ready if TX buffer is non-empty and program_select bits is 0
    
    // UART RX prod reg assignment
    assign uart_rx_prod_reg = uart_rx_prod; 

    // uart_rx_prod update process
    always @(posedge i_clk) begin
        if (i_rst) begin
            uart_rx_prod <= 'h0;
        end else begin
            if (i_uart_rx_wvalid & o_uart_rx_wready) begin
                uart_rx_prod <= uart_rx_prod + 1;

                uart_rx_buffer[uart_rx_prod[`UART_RX_PROD_BW-2:1]][((uart_rx_prod[0])?0:8)+:8] <= i_uart_rx_wdata;
            end
        end
    end

    // UART RX cons reg assignment
    assign uart_rx_cons_reg = uart_rx_cons; 

    // uart_rx_cons update process
    always @(posedge i_clk) begin
        if (i_rst) uart_rx_cons <= 'h0;
        else begin
            if (i_modbus_wren && (i_modbus_addr == `UART_RX_CONS_REG))
                uart_rx_cons <= i_modbus_din[`UART_RX_CONS_MSB_BP:`UART_RX_CONS_LSB_BP];
        end
    end

    assign o_uart_rx_wready = ~uart_rx_overflow; // Write only if RX buffer is not full
    
    // GPIO pattern reg assignment
    always @* begin
        gpio_pattern_reg = 16'h0;

        gpio_pattern_reg[`GPIO_MISMATCH_COUNT_MSB_BP:`GPIO_MISMATCH_COUNT_LSB_BP] = gpio_mismatch_count;   
        gpio_pattern_reg[`GPIO_PATTERN_LEN_MSB_BP:`GPIO_PATTERN_LEN_LSB_BP]       = o_gpio_pattern_len;   
    end

    // GPIO pattern field update process
    always @(posedge i_clk) begin
        if (i_rst) begin
            gpio_mismatch_count <= 'h0;
            o_gpio_pattern_len  <= 'h0;
        end else begin
            if (i_gpio_mismatch_clr)
                gpio_mismatch_count <= 'h0;
            else if (i_test_running && i_gpio_mismatch_incr)
                gpio_mismatch_count <= gpio_mismatch_count + 1'b1;
            else if (!i_test_running && i_modbus_wren && (i_modbus_addr == `GPIO_PATTERN_REG))
                gpio_mismatch_count <= i_modbus_din[`GPIO_MISMATCH_COUNT_MSB_BP:`GPIO_MISMATCH_COUNT_LSB_BP];

            if (i_gpio_pattern_len_update)
                o_gpio_pattern_len <= {1'b0, i_gpio_pattern_len[`GPIO_PATTERN_LEN_MSB_BP:`GPIO_PATTERN_LEN_LSB_BP]};
            else if (!i_test_running && i_modbus_wren && (i_modbus_addr == `GPIO_PATTERN_REG))
                o_gpio_pattern_len <= {1'b0, i_modbus_din[`GPIO_PATTERN_LEN_MSB_BP:`GPIO_PATTERN_LEN_LSB_BP]};
        end
    end

    // Proglen register assignments
    assign prog_cm_proglen_reg = o_cm_proglen; 
    assign prog_ct_proglen_reg = o_ct_proglen; 
    assign prog_a0_proglen_reg = o_a0_proglen; 

    // Proglen register update process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_cm_proglen <= 'h0;
            o_ct_proglen <= 'h0;
            o_a0_proglen <= 'h0;
        end else begin
            if (i_proglen_update) begin
                o_cm_proglen <= i_cm_proglen_update_data;
                o_ct_proglen <= i_ct_proglen_update_data;
                o_a0_proglen <= i_a0_proglen_update_data;
            end else begin
                if (i_modbus_wren && (i_modbus_addr == `PROG_CM_PROGLEN_REG))
                    o_cm_proglen <= i_modbus_din[`CM_PROGLEN_MSB_BP:`CM_PROGLEN_LSB_BP];
                if (i_modbus_wren && (i_modbus_addr == `PROG_CT_PROGLEN_REG))
                    o_ct_proglen <= i_modbus_din[`CT_PROGLEN_MSB_BP:`CT_PROGLEN_LSB_BP];
                if (i_modbus_wren && (i_modbus_addr == `PROG_A0_PROGLEN_REG))
                    o_a0_proglen <= i_modbus_din[`A0_PROGLEN_MSB_BP:`A0_PROGLEN_LSB_BP];
            end
        end
    end

    // MEMRW register assignments
    // assign o_memrw_valid = |o_memrw_sel;

    always @* begin
        memrw_addr_reg = 16'h0;

        memrw_addr_reg[`MEMRW_SEL_MSB_BP:`MEMRW_SEL_LSB_BP]   = o_memrw_sel;
        memrw_addr_reg[`MEMRW_WEN_BP]                         = o_memrw_wen;
        memrw_addr_reg[`MEMRW_ADDR_MSB_BP:`MEMRW_ADDR_LSB_BP] = o_memrw_addr;
    end

    always @(posedge i_clk) begin
        if (i_rst) begin
            memrw_datalo_reg <= 16'h0;    
            memrw_datahi_reg <= 16'h0;
            
            o_memrw_valid    <= 1'b0;
            o_memrw_wen      <= 1'b0;
            o_memrw_sel      <= 2'h0;
            o_memrw_addr     <= 12'h0;
            o_memrw_wdata    <= 32'h0;
        end else begin
            o_memrw_valid    <= 1'b0; 

            if (i_modbus_wren && (i_modbus_addr == `MEMRW_DATALO_REG))
                memrw_datalo_reg <= i_modbus_din;
            if (i_modbus_wren && (i_modbus_addr == `MEMRW_DATAHI_REG))
                memrw_datahi_reg <= i_modbus_din;
            if (i_modbus_wren && (i_modbus_addr == `MEMRW_ADDR_REG)) begin
                o_memrw_valid    <= i_modbus_din[`MEMRW_VALID_BP];
                o_memrw_wen      <= i_modbus_din[`MEMRW_WEN_BP];
                o_memrw_sel      <= i_modbus_din[`MEMRW_SEL_MSB_BP:`MEMRW_SEL_LSB_BP];
                o_memrw_addr     <= i_modbus_din[`MEMRW_ADDR_MSB_BP:`MEMRW_ADDR_LSB_BP];
                o_memrw_wdata    <= {memrw_datahi_reg, memrw_datalo_reg};    
            end

            if (i_memrw_ready & ~memrw_ready_q1 & ~o_memrw_wen) begin // Get memrw read data
                memrw_datalo_reg <= i_memrw_rdata[15:0];
                memrw_datahi_reg <= i_memrw_rdata[31:16];
            end
        end
    end

    // Soft Reset reg assignment
    assign soft_reset_reg = o_soft_reset; 

    // o_soft_reset update process
    always @(posedge i_clk) begin
        if (i_rst) o_soft_reset <= 'h0;
        else begin
            o_soft_reset <= 'h0;

            if (i_modbus_wren && (i_modbus_addr == `SOFT_RESET_REG))
                o_soft_reset <= i_modbus_din[`SOFT_RESET_BP];
        end
    end

    // uart_tx_buffer read/write process
    always @(posedge i_clk) begin
        if (i_rst)
            uart_tx_buffer_rdata <= 16'h0;
        else begin
            casez (i_modbus_addr)
                `UART_TX_BUFFER: begin    
                    if (i_modbus_wren) 
                        uart_tx_buffer[i_modbus_addr[`UART_TX_PROD_BW-3:0]] <= i_modbus_din;
                    if (i_modbus_rden)
                        uart_tx_buffer_rdata <= uart_tx_buffer[i_modbus_addr[`UART_TX_PROD_BW-3:0]];
                end
            endcase
        end
    end

    // uart_rx_buffer read process
    always @(posedge i_clk) begin
        if (i_rst)
            uart_rx_buffer_rdata <= 16'h0;
        else begin
            casez (i_modbus_addr)
                `UART_RX_BUFFER: begin    
                    if (i_modbus_rden)
                        uart_rx_buffer_rdata <= uart_rx_buffer[i_modbus_addr[`UART_RX_PROD_BW-3:0]];
                end
            endcase
        end
    end

    // gpio_input_buffer read/write process
    always @(posedge i_clk) begin
        if (i_rst)
            gpio_input_buffer_rdata <= 16'h0;
        else begin
            casez (i_modbus_addr)
                `GPIO_INPUT_BUFFER: begin    
                    if (i_modbus_wren) 
                        gpio_input_buffer[i_modbus_addr[`GPIO_PATTERN_LEN_BW-1:0]] <= i_modbus_din;
                    if (i_modbus_rden)
                        gpio_input_buffer_rdata <= gpio_input_buffer[i_modbus_addr[`GPIO_PATTERN_LEN_BW-1:0]];
                end
            endcase
        end
    end

    // gpio_output_chk_buffer read/write process
    always @(posedge i_clk) begin
        if (i_rst)
            gpio_output_chk_buffer_rdata <= 16'h0;
        else begin
            casez (i_modbus_addr)
                `GPIO_OUTPUT_CHK_BUFFER: begin    
                    if (i_modbus_wren) 
                        gpio_output_chk_buffer[i_modbus_addr[`GPIO_PATTERN_LEN_BW-1:0]] <= i_modbus_din;
                    if (i_modbus_rden)
                        gpio_output_chk_buffer_rdata <= gpio_output_chk_buffer[i_modbus_addr[`GPIO_PATTERN_LEN_BW-1:0]];
                end
            endcase
        end
    end

    // gpio_output_act_buffer read/write process
    always @(posedge i_clk) begin
        if (i_rst)
            gpio_output_act_buffer_rdata <= 16'h0;
        else begin
            casez (i_modbus_addr)
                `GPIO_OUTPUT_ACT_BUFFER: begin    
                    if (i_modbus_rden)
                        gpio_output_act_buffer_rdata <= gpio_output_act_buffer[i_modbus_addr[`GPIO_PATTERN_LEN_BW-1:0]];
                end
            endcase
        end
    end

    // GPIO Pattern read&write interface process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_gpio_pattern_ready   <= 1'b0;

            o_gpio_pattern_input_data       <= 11'h0;
            o_gpio_pattern_output_chk_data  <= 11'h0;
        end else begin
            o_gpio_pattern_ready   <= 1'b1;

            if (i_gpio_pattern_ren) begin
                o_gpio_pattern_input_data       <= gpio_input_buffer[i_gpio_pattern_addr];
                o_gpio_pattern_output_chk_data  <= gpio_output_chk_buffer[i_gpio_pattern_addr];
            end

            if (i_gpio_pattern_wen[0]) 
                gpio_input_buffer[i_gpio_pattern_addr]  <= i_gpio_pattern_input_data;
            if (i_gpio_pattern_wen[1]) 
                gpio_output_chk_buffer[i_gpio_pattern_addr] <= i_gpio_pattern_output_chk_data;
            if (i_gpio_pattern_wen[2]) 
                gpio_output_act_buffer[i_gpio_pattern_addr] <= i_gpio_pattern_output_act_data;

        end
    end

    // PROGMEM process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_progmem_ready <= 1'b0;
            o_progmem_rdata <= 32'h0;
        end else begin
            if (i_progmem_loading | i_progmem_fetching) begin // Controller memory interface access
                o_progmem_ready <= 1'b1;

                if (i_progmem_valid) begin
                    casez (i_progmem_addr) // Check if the shared memory part is accessed, if not, access to the local memories
                        `MEMSEL_SHD:
                            if (i_progmem_wen) progmem_shd[i_progmem_addr[5:0]] <= i_progmem_wdata;
                            else o_progmem_rdata <= progmem_shd[i_progmem_addr[5:0]];
                        `MEMSEL_SHD_MASK:
                            if (i_progmem_wen) progmem_shd_mask[i_progmem_addr[0]] <= i_progmem_wdata;
                            else o_progmem_rdata <= progmem_shd_mask[i_progmem_addr[0]];
                        default: begin
                            casez (i_progmem_sel)
                                `PROGSEL_CM: begin
                                    casez (i_progmem_addr)
                                        `MEMSEL_CM:
                                            if (i_progmem_wen) progmem_cm[i_progmem_addr] <= i_progmem_wdata;
                                            else o_progmem_rdata <= progmem_cm[i_progmem_addr];
                                    endcase
                                end
                                `PROGSEL_CT: begin
                                    casez (i_progmem_addr)
                                        `MEMSEL_CT:
                                            if (i_progmem_wen) progmem_ct[i_progmem_addr] <= i_progmem_wdata;
                                            else o_progmem_rdata <= progmem_ct[i_progmem_addr];
                                    endcase
                                end
                                `PROGSEL_A0: begin
                                    casez (i_progmem_addr)
                                        `MEMSEL_A0:
                                            if (i_progmem_wen) progmem_a0[i_progmem_addr] <= i_progmem_wdata;
                                            else o_progmem_rdata <= progmem_a0[i_progmem_addr];
                                    endcase
                                end
                            endcase
                        end
                    endcase
                end
            end else begin // Modbus access
                o_progmem_ready <= 1'b0;

                casez (i_modbus_addr)
                    `PROGMEM_CM:
                        if (i_modbus_wren) progmem_cm[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_progmem_rdata <= progmem_cm[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `PROGMEM_CT: // Put extra decode logic special to CT
                        if (i_modbus_wren) progmem_ct[{~i_modbus_addr[12], i_modbus_addr[11:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_progmem_rdata <= progmem_ct[{~i_modbus_addr[12], i_modbus_addr[11:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `PROGMEM_A0:
                        if (i_modbus_wren) progmem_a0[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_progmem_rdata <= progmem_a0[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `PROGMEM_SHD:
                        if (i_modbus_wren) progmem_shd[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_progmem_rdata <= progmem_shd[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `PROGMEM_SHD_MASK:
                        if (i_modbus_wren) progmem_shd_mask[i_modbus_addr[1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_progmem_rdata <= progmem_shd_mask[i_modbus_addr[1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                endcase
            end
        end
    end

    // CHKMEM process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_chkmem_ready <= 1'b0;
            o_chkmem_rdata <= 32'h0;
        end else begin
            if (i_progmem_loading | i_progmem_fetching | i_actmem_fetching) begin // Controller memory interface access
                o_chkmem_ready <= 1'b1;

                if (i_chkmem_valid) begin
                    casez (i_chkmem_addr) // Check if the shared memory part is accessed, if not, access to the local memories
                        `MEMSEL_SHD:
                            if (i_chkmem_wen) chkmem_shd[i_chkmem_addr[5:0]] <= i_chkmem_wdata;
                            else o_chkmem_rdata <= chkmem_shd[i_chkmem_addr[5:0]];
                        `MEMSEL_CM_MASK:
                            if (i_chkmem_wen) chkmem_cm_mask[i_chkmem_addr[5:0]] <= i_chkmem_wdata;
                            else o_chkmem_rdata <= chkmem_cm_mask[i_chkmem_addr[5:0]];
                        `MEMSEL_CT_MASK:
                            if (i_chkmem_wen) chkmem_ct_mask[{~i_chkmem_addr[6], i_chkmem_addr[5:0]}] <= i_chkmem_wdata;
                            else o_chkmem_rdata <= chkmem_ct_mask[{~i_chkmem_addr[6], i_chkmem_addr[5:0]}];
                        `MEMSEL_A0_MASK:
                            if (i_chkmem_wen) chkmem_a0_mask[i_chkmem_addr[5:0]] <= i_chkmem_wdata;
                            else o_chkmem_rdata <= chkmem_a0_mask[i_chkmem_addr[5:0]];
                        `MEMSEL_SHD_MASK:
                            if (i_chkmem_wen) chkmem_shd_mask[i_chkmem_addr[0]] <= i_chkmem_wdata;
                            else o_chkmem_rdata <= chkmem_shd_mask[i_chkmem_addr[0]];
                        default: begin
                            casez (i_chkmem_sel)
                                `PROGSEL_CM: begin
                                    casez (i_chkmem_addr)
                                        `MEMSEL_CM:
                                            if (i_chkmem_wen) chkmem_cm[i_chkmem_addr] <= i_chkmem_wdata;
                                            else o_chkmem_rdata <= chkmem_cm[i_chkmem_addr];
                                    endcase
                                end
                                `PROGSEL_CT: begin
                                    casez (i_chkmem_addr)
                                        `MEMSEL_CT:
                                            if (i_chkmem_wen) chkmem_ct[i_chkmem_addr] <= i_chkmem_wdata;
                                            else o_chkmem_rdata <= chkmem_ct[i_chkmem_addr];
                                    endcase
                                end
                                `PROGSEL_A0: begin
                                    casez (i_chkmem_addr)
                                        `MEMSEL_A0:
                                            if (i_chkmem_wen) chkmem_a0[i_chkmem_addr] <= i_chkmem_wdata;
                                            else o_chkmem_rdata <= chkmem_a0[i_chkmem_addr];
                                    endcase
                                end
                            endcase
                        end
                    endcase
                end
            end else begin // Modbus access
                o_chkmem_ready <= 1'b0;
                
                casez (i_modbus_addr)
                    `CHKMEM_CM:
                        if (i_modbus_wren) chkmem_cm[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_cm[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_CT: // Put extra decode logic special to CT
                        if (i_modbus_wren) chkmem_ct[{~i_modbus_addr[12], i_modbus_addr[11:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_ct[{~i_modbus_addr[12], i_modbus_addr[11:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_A0:
                        if (i_modbus_wren) chkmem_a0[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_a0[i_modbus_addr[11:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_SHD:
                        if (i_modbus_wren) chkmem_shd[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_shd[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_CM_MASK:
                        if (i_modbus_wren) chkmem_cm_mask[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_cm_mask[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_CT_MASK:
                        if (i_modbus_wren) chkmem_ct_mask[{~i_modbus_addr[7], i_modbus_addr[6:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_ct_mask[{~i_modbus_addr[7], i_modbus_addr[6:1]}][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_A0_MASK:
                        if (i_modbus_wren) chkmem_a0_mask[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_a0_mask[i_modbus_addr[6:1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                    `CHKMEM_SHD_MASK:
                        if (i_modbus_wren) chkmem_shd_mask[i_modbus_addr[1]][((i_modbus_addr[0]) ? 0 : 16)+:16] <= i_modbus_din;
                        else if (i_modbus_rden) o_chkmem_rdata <= chkmem_shd_mask[i_modbus_addr[1]][((i_modbus_addr[0]) ? 0 : 16)+:16];
                endcase
            end
        end
    end

    // ACTMEM process
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_actmem_ready  <= 1'b0;
            actmem_rdata    <= 32'h0;
        end else begin
            if (i_actmem_fetching) begin // Controller memory interface access
                o_actmem_ready <= 1'b1;

                if (i_actmem_valid) begin
                    casez (i_actmem_addr) // Check if the shared memory part is accessed, if not, access to the local memories
                        `MEMSEL_SHD:
                            if (i_actmem_valid) actmem_shd[i_actmem_addr[5:0]] <= i_actmem_wdata;
                        default: begin
                            casez (i_actmem_sel)
                                `PROGSEL_CM: begin
                                    casez (i_actmem_addr)
                                        `MEMSEL_CM:
                                            if (i_actmem_valid) actmem_cm[i_actmem_addr] <= i_actmem_wdata;
                                    endcase
                                end
                                `PROGSEL_CT: begin
                                    casez (i_actmem_addr)
                                        `MEMSEL_CT:
                                            if (i_actmem_valid) actmem_ct[i_actmem_addr] <= i_actmem_wdata;
                                    endcase
                                end
                                `PROGSEL_A0: begin
                                    casez (i_actmem_addr)
                                        `MEMSEL_A0:
                                            if (i_actmem_valid) actmem_a0[i_actmem_addr] <= i_actmem_wdata;
                                    endcase
                                end
                            endcase
                        end
                    endcase
                end
            end else begin // Modbus access
                o_actmem_ready <= 1'b0;
                
                casez (i_modbus_addr)
                    `ACTMEM_CM:
                        if (i_modbus_rden) actmem_rdata <= actmem_cm[i_modbus_addr[11:1]];
                    `ACTMEM_CT: // Put extra decode logic special to CT
                        if (i_modbus_rden) actmem_rdata <= actmem_ct[{~i_modbus_addr[12], i_modbus_addr[11:1]}];
                    `ACTMEM_A0:
                        if (i_modbus_rden) actmem_rdata <= actmem_a0[i_modbus_addr[11:1]];
                    `ACTMEM_SHD:
                        if (i_modbus_rden) actmem_rdata <= actmem_shd[i_modbus_addr[6:1]];
                endcase
            end
        end
    end

    // CHKMEM MISMATCH process
    always @(posedge i_clk) begin
        if (i_rst) begin
            chkmem_cm_mismatch_reg  <= 16'h0;
            chkmem_ct_mismatch_reg  <= 16'h0;
            chkmem_a0_mismatch_reg  <= 16'h0;
            chkmem_shd_mismatch_reg <= 16'h0;
        end else begin
            if (i_test_running) begin // Controller memory interface access
                if (i_chkmem_cm_mismatch_incr)  chkmem_cm_mismatch_reg  <= chkmem_cm_mismatch_reg + 1; 
                if (i_chkmem_ct_mismatch_incr)  chkmem_ct_mismatch_reg  <= chkmem_ct_mismatch_reg + 1; 
                if (i_chkmem_a0_mismatch_incr)  chkmem_a0_mismatch_reg  <= chkmem_a0_mismatch_reg + 1; 
                if (i_chkmem_shd_mismatch_incr) chkmem_shd_mismatch_reg <= chkmem_shd_mismatch_reg + 1; 

            if (i_chkmem_mismatch_clr) begin
                chkmem_cm_mismatch_reg  <= 16'h0;
                chkmem_ct_mismatch_reg  <= 16'h0;
                chkmem_a0_mismatch_reg  <= 16'h0;
                chkmem_shd_mismatch_reg <= 16'h0;
                end
            end else begin // Modbus access
                if (i_modbus_wren && (i_modbus_addr == `CHKMEM_CM_MISMATCH_REG))
                    chkmem_cm_mismatch_reg  <= i_modbus_din;
                if (i_modbus_wren && (i_modbus_addr == `CHKMEM_CT_MISMATCH_REG))
                    chkmem_ct_mismatch_reg  <= i_modbus_din;
                if (i_modbus_wren && (i_modbus_addr == `CHKMEM_A0_MISMATCH_REG))
                    chkmem_a0_mismatch_reg  <= i_modbus_din;
                if (i_modbus_wren && (i_modbus_addr == `CHKMEM_SHD_MISMATCH_REG))
                    chkmem_shd_mismatch_reg <= i_modbus_din;
            end
        end
    end

endmodule
