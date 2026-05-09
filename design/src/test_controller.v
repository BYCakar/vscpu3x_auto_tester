`include "Modbus_Regspace_defines.vh"

`define CMDUART_SHD_START 14'h2000
`define CMDUART_SHD_END 14'h203f

module test_controller 
    (
        // Clock, reset and enable pins
	    input               i_clk,
        input               i_rst,

        output              o_vscpu3x_rst,
        output reg  [1:0]   o_vscpu3x_program_sel,
        
        // Interface with test controller
        // Command signals
        input               i_fetch_actmem,
        input               i_fetch_progmem,
        input               i_force_stop,
        input               i_test_load_run,
        input               i_test_fast_run,

        // Status signals
        output              o_progmem_loading,
        output              o_actmem_fetching,
        output              o_progmem_fetching,
        output              o_progmode,

        // Error signals
        output              o_program_error,
        input               i_program_error_clr,
        
        // Test num
        input       [3:0]   i_testnum,

        // Test start and test done
        output              o_test_start,
        input               i_test_done,

        // GPIO pattern buffer access signals
        output              o_gpio_mismatch_clr,

        output              o_gpio_pattern_len_update,
        input       [7:0]   i_gpio_pattern_len,

        input               i_gpio_pattern_ready,
        output              o_gpio_pattern_ren,
        output              o_gpio_pattern_wen,
        input       [10:0]  i_gpio_pattern_input_data,
        input       [10:0]  i_gpio_pattern_output_chk_data,
        output      [10:0]  o_gpio_pattern_output_act_data,

        // PROGMEM access signals
        input       [10:0]  i_cm_proglen,
        input       [11:0]  i_ct_proglen,
        input       [10:0]  i_a0_proglen,

        input               i_progmem_ready,
        output reg          o_progmem_valid,
        output reg          o_progmem_wen,
        output reg  [1:0]   o_progmem_sel,
        output reg  [11:0]  o_progmem_addr,
        output reg  [31:0]  o_progmem_wdata,
        input       [31:0]  i_progmem_rdata,

        // CHKMEM access signals
        output              o_chkmem_mismatch_clr,
        output              o_chkmem_cm_mismatch_incr,
        output              o_chkmem_ct_mismatch_incr,
        output              o_chkmem_a0_mismatch_incr,
        output              o_chkmem_shd_mismatch_incr,

        input               i_chkmem_ready,
        output reg          o_chkmem_valid,
        output reg          o_chkmem_wen,
        output reg  [1:0]   o_chkmem_sel,
        output reg  [11:0]  o_chkmem_addr,
        output reg  [31:0]  o_chkmem_wdata,
        input       [31:0]  i_chkmem_rdata,
        
        // ACTMEM access signals
        input               i_actmem_ready,
        output reg          o_actmem_valid,
        output reg  [1:0]   o_actmem_sel,
        output reg  [11:0]  o_actmem_addr,
        output reg  [31:0]  o_actmem_wdata,
        
        // MEMRW access signals
        output              o_memrw_ready,
        input               i_memrw_valid,
        input               i_memrw_wen,
        input       [1:0]   i_memrw_sel,  
        input       [11:0]  i_memrw_addr,
        input       [31:0]  i_memrw_wdata,
        output      [31:0]  o_memrw_rdata,

        output reg          o_progrom_ren,
        output reg  [1:0]   o_progrom_sel,
        output reg  [11:0]  o_progrom_addr,
        input       [31:0]  i_progrom_rdata,

        output reg          o_chkrom_ren,
        output      [1:0]   o_chkrom_sel,
        output      [11:0]  o_chkrom_addr,
        input       [31:0]  i_chkrom_rdata,

        // CMDUART access signals
        output reg          o_cmduart_start,
        output reg          o_cmduart_wen,
        input               i_cmduart_done,
        input               i_cmduart_busy,
        input               i_cmduart_err,
        output reg  [13:0]  o_cmduart_addr,
        input       [31:0]  i_cmduart_rdata,
        output reg  [31:0]  o_cmduart_wdata
    );

    localparam S_IDLE           = 4'h0;
    localparam S_FETCH_ACTMEM   = 4'h1;
    localparam S_FETCH_PROGMEM  = 4'h2;
    localparam S_TEST_LOAD_RUN  = 4'h3;
    localparam S_TEST_FAST_RUN  = 4'h4;
    localparam S_RUN_TEST       = 4'h5;
    localparam S_CHECK_MEMORY   = 4'h6;

    reg  [3:0] state;

    reg  [7:0] vscpu3x_rst_counter;

    reg  [31:0] chk_mask;

    reg  [11:0] progrom_addr_q1;
        

    assign o_chkrom_sel  = o_progrom_sel;
    assign o_chkrom_addr = o_progrom_addr;
    
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_vscpu3x_program_sel <= 2'h0;

            o_cmduart_start <= 1'b0;
            o_cmduart_wen   <= 1'b0;
            o_cmduart_addr  <= 14'h0;
            o_cmduart_wdata <= 32'h0;

            o_actmem_valid  <= 1'b0;
            o_actmem_sel    <= 2'h0;
            o_actmem_addr   <= 14'h0;
            o_actmem_wdata  <= 32'h0;

            o_progrom_ren   <= 1'b0;
            o_progrom_sel   <= 2'h0;
            o_progrom_addr  <= 14'h0;
            progrom_addr_q1 <= 14'h0;

            o_progmem_valid <= 1'b0;
            o_progmem_wen   <= 1'b0;
            o_progmem_sel   <= 2'h0;
            o_progmem_addr  <= 12'h0;
            o_progmem_wdata <= 32'h0;

            o_chkmem_valid  <= 1'b0;
            o_chkmem_wen    <= 1'b0;
            o_chkmem_sel    <= 2'h0;
            o_chkmem_addr   <= 12'h0;
            o_chkmem_wdata  <= 32'h0;

            o_chkrom_ren    <= 1'b0;

            state <= S_IDLE;
        end else begin
            progrom_addr_q1 <= o_progrom_addr;

            o_progmem_valid <= 1'b0;
            o_chkmem_valid  <= 1'b0;
            o_actmem_valid  <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (i_fetch_actmem)  begin
                        o_vscpu3x_program_sel <= `PROGSEL_CM;

                        o_cmduart_addr  <= 14'h0;
                        o_cmduart_start <= 1'b1;

                        state <= S_FETCH_ACTMEM;
                    end
                    if (i_fetch_progmem) begin
                        o_progrom_sel   <= `PROGSEL_CM;
                        o_progrom_addr  <= `MEMSEL_CM_MASK_START;
                        o_progrom_ren   <= 1'b0;
                        o_chkrom_ren    <= 1'b1;

                        o_progmem_wen   <= 1'b1;
                        o_chkmem_wen    <= 1'b1;

                        state <= S_FETCH_PROGMEM;
                    end
                    if (i_test_load_run) state <= S_TEST_LOAD_RUN;
                    if (i_test_fast_run) state <= S_TEST_FAST_RUN;
                end
                S_FETCH_ACTMEM: begin // TODO: Here progsel signal may not be in an ideal position such as 0, you need to work on the progsel transitions according to states
                    if (i_cmduart_done) begin
                        if (i_cmduart_err) 
                            o_cmduart_start <= 1'b1;
                        else begin
                            o_cmduart_addr  <= o_cmduart_addr + 1;
                            o_cmduart_start <= 1'b1;

                            case (o_vscpu3x_program_sel) 
                                `PROGSEL_CM: begin
                                    if (o_cmduart_addr == `MEMSEL_CM_END) begin
                                        o_vscpu3x_program_sel <= `PROGSEL_A0;
                                        o_cmduart_addr  <= 14'h0;
                                    end
                                end
                                `PROGSEL_CT: begin
                                    if (o_cmduart_addr == `MEMSEL_CT_END) begin
                                        o_cmduart_addr  <= `CMDUART_SHD_START; // Switch to the shared memory
                                    end

                                    if (o_cmduart_addr == `CMDUART_SHD_END) begin
                                        o_cmduart_addr  <= 14'h0; // Finish the job and return IDLE

                                        o_cmduart_start <= 1'b0;
                                        state <= S_IDLE;
                                    end
                                end
                                `PROGSEL_A0: begin
                                    if (o_cmduart_addr == `CMDUART_SHD_END) begin
                                        o_vscpu3x_program_sel <= `PROGSEL_CT;
                                        o_cmduart_addr  <= 14'h0;
                                    end
                                end
                            endcase

                            o_actmem_sel    <= o_vscpu3x_program_sel;
                            o_actmem_addr   <= (o_cmduart_addr > `CMDUART_SHD_START) ? `MEMSEL_SHD_START + o_cmduart_addr[5:0] : o_cmduart_addr[11:0]; // Do shared mem address conversion
                            o_actmem_wdata  <= i_cmduart_rdata;
                            o_actmem_valid  <= 1'b1;
                        end
                    end
                end
                S_FETCH_PROGMEM: begin                        
                    progrom_addr_q1 <= o_progrom_addr;

                    casez (o_progrom_addr)
                        `MEMSEL_CM_MASK,
                        `MEMSEL_CT_MASK,
                        `MEMSEL_A0_MASK,
                        `MEMSEL_SHD_MASK: begin
                            casez (o_progrom_addr)
                                `MEMSEL_CM_MASK:  o_progrom_addr  <= `MEMSEL_CM_START + ((o_progrom_addr - `MEMSEL_CM_MASK_START) << 5);
                                `MEMSEL_CT_MASK:  o_progrom_addr  <= `MEMSEL_CT_START + ((o_progrom_addr - `MEMSEL_CT_MASK_START) << 5);
                                `MEMSEL_A0_MASK:  o_progrom_addr  <= `MEMSEL_A0_START + ((o_progrom_addr - `MEMSEL_A0_MASK_START) << 5);
                                `MEMSEL_SHD_MASK: o_progrom_addr  <= `MEMSEL_SHD_START + ((o_progrom_addr - `MEMSEL_SHD_MASK_START) << 5); 
                            endcase

                            case (o_progrom_sel)
                                `PROGSEL_CM: o_progrom_ren <= ((`MEMSEL_CM_START + ((o_progrom_addr - `MEMSEL_CM_MASK_START) << 5)) < i_cm_proglen);
                                `PROGSEL_CT: o_progrom_ren <= ((`MEMSEL_CT_START + ((o_progrom_addr - `MEMSEL_CT_MASK_START) << 5)) < i_ct_proglen);
                                `PROGSEL_A0: o_progrom_ren <= ((`MEMSEL_A0_START + ((o_progrom_addr - `MEMSEL_A0_MASK_START) << 5)) < i_a0_proglen);
                            endcase

                            if ((o_progrom_addr[11:0] & 12'hffe) == (`MEMSEL_SHD_MASK_START & 12'hffe)) o_progrom_ren <= 1'b1;
                        end
                        default: begin
                            o_progrom_addr  <= o_progrom_addr + 1;
                             
                            case (o_progrom_sel)
                                `PROGSEL_CM: begin
                                    if (o_progrom_addr == `MEMSEL_CM_END) begin
                                        o_progrom_sel   <= `PROGSEL_A0;
                                        o_progrom_addr  <= `MEMSEL_A0_START;
                                        o_progrom_ren   <= 1'b0;
                                    end 
                                end
                                `PROGSEL_CT: begin
                                    if (o_progrom_addr != 12'hfff) begin
                                        if (o_progrom_addr == `MEMSEL_CT_END) begin
                                            o_progrom_addr  <= `MEMSEL_SHD_MASK_START;
                                            o_progrom_ren   <= 1'b0;
                                        end 
                                        else if (o_progrom_addr == `MEMSEL_SHD_END) begin
                                            o_progrom_addr  <= 12'hfff;
                                            o_progrom_ren   <= 1'b0;
                                            o_chkrom_ren    <= 1'b0;
                                        end
                                        else if(o_progrom_addr[4:0] == 5'h1f) begin
                                            o_progrom_addr  <= `MEMSEL_CT_MASK_START + ((o_progrom_addr - `MEMSEL_CT_START) >> 5);
                                            o_progrom_ren   <= 1'b0;                                            
                                        end
                                    end
                                end
                                `PROGSEL_A0: begin
                                    if (o_progrom_addr == `MEMSEL_A0_END) begin
                                        o_progrom_sel   <= `PROGSEL_CT;
                                        o_progrom_addr  <= `MEMSEL_CT_MASK_START;
                                        o_progrom_ren   <= 1'b0;
                                    end 
                                    else if(o_progrom_addr[4:0] == 5'h1f) begin
                                        o_progrom_addr  <= `MEMSEL_A0_MASK_START + ((o_progrom_addr - `MEMSEL_A0_START) >> 5);
                                        o_progrom_ren   <= 1'b0;
                                    end
                                end
                            endcase
                        end
                    endcase

                    casez (progrom_addr_q1)
                        `MEMSEL_CM_MASK,
                        `MEMSEL_CT_MASK,
                        `MEMSEL_A0_MASK,
                        `MEMSEL_SHD_MASK: begin
                            chk_mask        <= i_chkrom_rdata;

                            o_chkmem_valid  <= 1'b1;
                            o_chkmem_sel    <= o_chkrom_sel;
                            o_chkmem_addr   <= o_chkrom_addr;
                            o_chkmem_wdata  <= i_chkrom_rdata;
                        end
                        12'hfff: begin
                            o_progrom_sel   <= `PROGSEL_IDLE;
                            o_progmem_sel   <= `PROGSEL_IDLE;
                            o_chkmem_sel    <= `PROGSEL_IDLE;
                            
                            o_progmem_wen   <= 1'b0;
                            o_chkmem_wen    <= 1'b0;

                            state <= S_IDLE;
                        end 
                        default: begin
                            case (o_progrom_sel)
                                `PROGSEL_CM: o_progmem_valid <= (progrom_addr_q1 < i_cm_proglen);
                                `PROGSEL_CT: o_progmem_valid <= (progrom_addr_q1 < i_ct_proglen);
                                `PROGSEL_A0: o_progmem_valid <= (progrom_addr_q1 < i_a0_proglen);
                            endcase

                            o_progmem_sel   <= o_progrom_sel;
                            o_progmem_addr  <= o_progrom_addr;
                            o_progmem_wdata <= i_progrom_rdata;

                            o_chkmem_valid  <= chk_mask[progrom_addr_q1[4:0]];
                            o_chkmem_sel    <= o_chkrom_sel;
                            o_chkmem_addr   <= o_chkrom_addr;
                            o_chkmem_wdata  <= i_chkrom_rdata;
                        end
                    endcase
                end
                S_TEST_LOAD_RUN: begin
                    
                end
                S_TEST_FAST_RUN: begin
                    progrom_addr_q1 <= o_progrom_addr;

                    o_progrom_addr  <= o_progrom_addr + 1;
                     
                    case (o_progrom_sel)
                        `PROGSEL_CM: begin
                            if (o_progrom_addr == `MEMSEL_CM_END) begin
                                o_progrom_sel   <= `PROGSEL_A0;
                                o_progrom_addr  <= `MEMSEL_A0_MASK_START;
                                o_progrom_ren   <= 1'b0;
                            end 
                            else if(o_progrom_addr[4:0] == 5'h1f) begin
                                o_progrom_addr  <= `MEMSEL_CM_MASK_START + ((o_progrom_addr - `MEMSEL_CM_START) >> 5);
                                o_progrom_ren   <= 1'b0;
                            end
                        end
                        `PROGSEL_CT: begin
                            if (o_progrom_addr != 12'hfff) begin
                                if (o_progrom_addr == `MEMSEL_CT_END) begin
                                    o_progrom_addr  <= `MEMSEL_SHD_MASK_START;
                                    o_progrom_ren   <= 1'b0;
                                end 
                                else if (o_progrom_addr == `MEMSEL_SHD_END) begin
                                    o_progrom_addr  <= 12'hfff;
                                    o_progrom_ren   <= 1'b0;
                                    o_chkrom_ren    <= 1'b0;
                                end
                                else if(o_progrom_addr[4:0] == 5'h1f) begin
                                    o_progrom_addr  <= `MEMSEL_CT_MASK_START + ((o_progrom_addr - `MEMSEL_CT_START) >> 5);
                                    o_progrom_ren   <= 1'b0;                                            
                                end
                            end
                        end
                        `PROGSEL_A0: begin
                            if (o_progrom_addr == `MEMSEL_A0_END) begin
                                o_progrom_sel   <= `PROGSEL_CT;
                                o_progrom_addr  <= `MEMSEL_CT_MASK_START;
                                o_progrom_ren   <= 1'b0;
                            end 
                            else if(o_progrom_addr[4:0] == 5'h1f) begin
                                o_progrom_addr  <= `MEMSEL_A0_MASK_START + ((o_progrom_addr - `MEMSEL_A0_START) >> 5);
                                o_progrom_ren   <= 1'b0;
                            end
                        end
                    endcase

                    casez (progrom_addr_q1)
                        `MEMSEL_CM_MASK,
                        `MEMSEL_CT_MASK,
                        `MEMSEL_A0_MASK,
                        `MEMSEL_SHD_MASK: begin
                            chk_mask        <= i_chkrom_rdata;

                            o_chkmem_valid  <= 1'b1;
                            o_chkmem_sel    <= o_chkrom_sel;
                            o_chkmem_addr   <= o_chkrom_addr;
                            o_chkmem_wdata  <= i_chkrom_rdata;
                        end
                        12'hfff: begin
                            o_progrom_sel   <= `PROGSEL_IDLE;
                            o_progmem_sel   <= `PROGSEL_IDLE;
                            o_chkmem_sel    <= `PROGSEL_IDLE;
                            
                            o_progmem_wen   <= 1'b0;
                            o_chkmem_wen    <= 1'b0;

                            state <= S_IDLE;
                        end 
                        default: begin
                            case (o_progrom_sel)
                                `PROGSEL_CM: o_progmem_valid <= (progrom_addr_q1 < i_cm_proglen);
                                `PROGSEL_CT: o_progmem_valid <= (progrom_addr_q1 < i_ct_proglen);
                                `PROGSEL_A0: o_progmem_valid <= (progrom_addr_q1 < i_a0_proglen);
                            endcase

                            o_progmem_sel   <= o_progrom_sel;
                            o_progmem_addr  <= o_progrom_addr;
                            o_progmem_wdata <= i_progrom_rdata;

                            o_chkmem_valid  <= chk_mask[progrom_addr_q1[4:0]];
                            o_chkmem_sel    <= o_chkrom_sel;
                            o_chkmem_addr   <= o_chkrom_addr;
                            o_chkmem_wdata  <= i_chkrom_rdata;
                        end
                    endcase
                end
                /*S_TEST_RUN: begin
                
                end
                S_TEST_CHECK: begin

                end*/

            endcase
        end
    end

    assign o_vscpu3x_rst = |vscpu3x_rst_counter;

    always @(posedge i_clk) begin
        if (i_rst) 
            vscpu3x_rst_counter <= 8'h0;
        else
            if (o_vscpu3x_program_sel)
                vscpu3x_rst_counter <= 8'hf;
            else
                vscpu3x_rst_counter <= (vscpu3x_rst_counter) ? vscpu3x_rst_counter -1 : 8'h0;
    end

endmodule