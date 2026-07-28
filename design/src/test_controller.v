`include "Modbus_Regspace_defines.vh"

`define CMDUART_SHD_START 14'h2000

module test_controller #(
        // Full clock cycles required on each side of a program_sel transition.
        parameter integer PROGRAM_SEL_MARGIN_CYCLES = 2
    )
    (
        input               i_clk,
        input               i_rst,

        output              o_vscpu3x_rst,
        output reg  [1:0]   o_vscpu3x_program_sel,
        input               i_cm_done,
        input               i_ct_done,
        input               i_a0_done,

        input               i_fetch_actmem,
        input               i_fetch_progmem,
        input               i_force_stop,
        input               i_test_load_run,
        input               i_test_fast_run,

        output              o_progmem_loading,
        output              o_actmem_fetching,
        output              o_progmem_fetching,
        output              o_progmode,
        output reg          o_test_running,
        output reg          o_a0_running,
        output reg          o_ct_running,
        output reg          o_cm_running,

        output              o_program_error,
        input               i_program_error_clr,

        output reg          o_memrw_error,
        output reg          o_test_start,

        input       [3:0]   i_testnum,

        output reg          o_gpio_mismatch_clr,
        output reg          o_gpio_pattern_len_update,
        output reg  [7:0]   o_gpio_pattern_len_update_data,

        input               i_gpio_pattern_ready,
        output reg          o_gpio_pattern_ren,
        output reg  [2:0]   o_gpio_pattern_wen,
        output reg  [7:0]   o_gpio_pattern_addr,
        output reg  [10:0]  o_gpio_pattern_input_data,
        output reg  [10:0]  o_gpio_pattern_output_chk_data,
        output reg  [10:0]  o_gpio_pattern_output_act_data,

        input       [10:0]  i_cm_proglen,
        input       [11:0]  i_ct_proglen,
        input       [10:0]  i_a0_proglen,
        output reg          o_proglen_update,
        output reg  [10:0]  o_cm_proglen_update_data,
        output reg  [11:0]  o_ct_proglen_update_data,
        output reg  [10:0]  o_a0_proglen_update_data,

        input               i_progmem_ready,
        output reg          o_progmem_valid,
        output reg          o_progmem_wen,
        output reg  [1:0]   o_progmem_sel,
        output reg  [11:0]  o_progmem_addr,
        output reg  [31:0]  o_progmem_wdata,
        input       [31:0]  i_progmem_rdata,

        output reg          o_chkmem_mismatch_clr,
        output reg          o_chkmem_cm_mismatch_incr,
        output reg          o_chkmem_ct_mismatch_incr,
        output reg          o_chkmem_a0_mismatch_incr,
        output reg          o_chkmem_shd_mismatch_incr,

        input               i_chkmem_ready,
        output reg          o_chkmem_valid,
        output reg          o_chkmem_wen,
        output reg  [1:0]   o_chkmem_sel,
        output reg  [11:0]  o_chkmem_addr,
        output reg  [31:0]  o_chkmem_wdata,
        input       [31:0]  i_chkmem_rdata,

        input               i_actmem_ready,
        output reg          o_actmem_valid,
        output reg  [1:0]   o_actmem_sel,
        output reg  [11:0]  o_actmem_addr,
        output reg  [31:0]  o_actmem_wdata,

        output reg          o_memrw_ready,
        input               i_memrw_valid,
        input               i_memrw_wen,
        input       [1:0]   i_memrw_sel,
        input       [11:0]  i_memrw_addr,
        input       [31:0]  i_memrw_wdata,
        output reg  [31:0]  o_memrw_rdata,

        input       [10:0]  i_rom_cm_proglen,
        input       [11:0]  i_rom_ct_proglen,
        input       [10:0]  i_rom_a0_proglen,
        input       [7:0]   i_rom_gpio_pattern_len,

        output reg          o_progrom_ren,
        output reg  [1:0]   o_progrom_sel,
        output reg  [11:0]  o_progrom_addr,
        input       [31:0]  i_progrom_rdata,

        output reg          o_chkrom_ren,
        output reg  [1:0]   o_chkrom_sel,
        output reg  [11:0]  o_chkrom_addr,
        input       [31:0]  i_chkrom_rdata,

        output reg  [7:0]   o_gpio_rom_addr,
        input       [10:0]  i_gpio_rom_input_data,
        input       [10:0]  i_gpio_rom_output_chk_data,

        output reg          o_cmduart_start,
        output reg          o_cmduart_wen,
        input               i_cmduart_done,
        input               i_cmduart_busy,
        input               i_cmduart_err,
        output reg  [13:0]  o_cmduart_addr,
        input       [31:0]  i_cmduart_rdata,
        output reg  [31:0]  o_cmduart_wdata,

        input               i_test_driver_done
    );

    localparam S_IDLE                 = 6'd0;
    localparam S_ROM_SECTION          = 6'd1;
    localparam S_LOAD_SECTION         = 6'd2;
    localparam S_LOAD_READ            = 6'd3;
    localparam S_LOAD_START           = 6'd4;
    localparam S_LOAD_WAIT            = 6'd5;
    localparam S_LOAD_SHD_MASK        = 6'd6;
    localparam S_LOAD_SHD_MASK_WAIT   = 6'd7;
    localparam S_LOAD_SHD_READ        = 6'd8;
    localparam S_LOAD_SHD_READ_WAIT   = 6'd22;
    localparam S_RUN                  = 6'd9;
    localparam S_FETCH_SECTION        = 6'd10;
    localparam S_FETCH_START          = 6'd11;
    localparam S_FETCH_WAIT           = 6'd12;
    localparam S_MASK_SECTION         = 6'd13;
    localparam S_MASK_READ            = 6'd14;
    localparam S_MASK_CHECK           = 6'd15;
    localparam S_MASK_EXPECT          = 6'd16;
    localparam S_MASK_EXPECT_WAIT     = 6'd17;
    localparam S_MASK_START           = 6'd18;
    localparam S_MASK_WAIT            = 6'd19;
    localparam S_MEMRW_START          = 6'd20;
    localparam S_MEMRW_WAIT           = 6'd21;
    localparam S_ROM_WRITE            = 6'd23;

    localparam SEC_CM_PROG            = 5'd0;
    localparam SEC_CT_PROG            = 5'd1;
    localparam SEC_A0_PROG            = 5'd2;
    localparam SEC_SHD_PROG           = 5'd3;
    localparam SEC_SHD_PROG_MASK      = 5'd4;
    localparam SEC_CM_CHK             = 5'd5;
    localparam SEC_CT_CHK             = 5'd6;
    localparam SEC_A0_CHK             = 5'd7;
    localparam SEC_SHD_CHK            = 5'd8;
    localparam SEC_CM_CHK_MASK        = 5'd9;
    localparam SEC_CT_CHK_MASK        = 5'd10;
    localparam SEC_A0_CHK_MASK        = 5'd11;
    localparam SEC_SHD_CHK_MASK       = 5'd12;
    localparam SEC_GPIO               = 5'd13;
    localparam SEC_DONE               = 5'd14;

    localparam CM_WORDS               = 12'd2048;
    localparam CT_WORDS               = 12'd2560;
    localparam A0_WORDS               = 12'd1536;
    localparam SHD_WORDS              = 12'd64;
    localparam CM_MASK_WORDS          = 12'd64;
    localparam CT_MASK_WORDS          = 12'd80;
    localparam A0_MASK_WORDS          = 12'd48;
    localparam SHD_MASK_WORDS         = 12'd2;

    reg  [5:0]  state;
    reg  [4:0]  section;
    reg         fast_run_pending;
    reg         loading_shared;
    reg  [11:0] word_idx;
    reg  [31:0] mask_word;
    reg  [31:0] expected_word;
    reg         program_error_reg;
    reg  [2:0]  done_meta;
    reg  [2:0]  done_sync;
    reg  [1:0]  program_sel_request;
    integer     cmduart_quiet_cycles;
    integer     program_sel_stable_cycles;

    // A selector update waits for UART quiet time; a UART access waits for the
    // newly applied selector to remain stable for the same interval.
    wire cmduart_margin_elapsed = (PROGRAM_SEL_MARGIN_CYCLES == 0) ||
                                   (cmduart_quiet_cycles >= PROGRAM_SEL_MARGIN_CYCLES);
    wire program_sel_margin_elapsed = (PROGRAM_SEL_MARGIN_CYCLES == 0) ||
                                      (program_sel_stable_cycles >= PROGRAM_SEL_MARGIN_CYCLES);
    wire program_sel_ready = (program_sel_request == o_vscpu3x_program_sel) &&
                             program_sel_margin_elapsed;

    assign o_vscpu3x_rst       = |o_vscpu3x_program_sel;
    assign o_progmode          = |o_vscpu3x_program_sel;
    assign o_program_error     = program_error_reg;
    assign o_progmem_fetching  = (state == S_ROM_SECTION) || (state == S_ROM_WRITE);
    assign o_progmem_loading   = (state == S_LOAD_SECTION) ||
                                  (state == S_LOAD_READ) ||
                                  (state == S_LOAD_START) ||
                                  (state == S_LOAD_WAIT) ||
                                  (state == S_LOAD_SHD_MASK) ||
                                  (state == S_LOAD_SHD_MASK_WAIT) ||
                                  (state == S_LOAD_SHD_READ) ||
                                  (state == S_LOAD_SHD_READ_WAIT);
    assign o_actmem_fetching   = (state == S_FETCH_SECTION) ||
                                  (state == S_FETCH_START) ||
                                  (state == S_FETCH_WAIT) ||
                                  (state == S_MASK_SECTION) ||
                                  (state == S_MASK_READ) ||
                                  (state == S_MASK_CHECK) ||
                                  (state == S_MASK_EXPECT) ||
                                  (state == S_MASK_EXPECT_WAIT) ||
                                  (state == S_MASK_START) ||
                                  (state == S_MASK_WAIT);

    function [11:0] prog_limit;
        input [4:0] sec;
        begin
            case (sec)
                SEC_CM_PROG:       prog_limit = {1'b0, i_rom_cm_proglen};
                SEC_CT_PROG:       prog_limit = i_rom_ct_proglen;
                SEC_A0_PROG:       prog_limit = {1'b0, i_rom_a0_proglen};
                SEC_SHD_PROG:      prog_limit = SHD_WORDS;
                SEC_SHD_PROG_MASK: prog_limit = SHD_MASK_WORDS;
                default:           prog_limit = 12'd0;
            endcase
        end
    endfunction

    function [11:0] chk_limit;
        input [4:0] sec;
        begin
            case (sec)
                SEC_CM_CHK:       chk_limit = CM_WORDS;
                SEC_CT_CHK:       chk_limit = CT_WORDS;
                SEC_A0_CHK:       chk_limit = A0_WORDS;
                SEC_SHD_CHK:      chk_limit = SHD_WORDS;
                SEC_CM_CHK_MASK:  chk_limit = CM_MASK_WORDS;
                SEC_CT_CHK_MASK:  chk_limit = CT_MASK_WORDS;
                SEC_A0_CHK_MASK:  chk_limit = A0_MASK_WORDS;
                SEC_SHD_CHK_MASK: chk_limit = SHD_MASK_WORDS;
                default:          chk_limit = 12'd0;
            endcase
        end
    endfunction

    function [11:0] run_limit;
        input [1:0] sel;
        begin
            case (sel)
                `PROGSEL_CM: run_limit = {1'b0, i_cm_proglen};
                `PROGSEL_CT: run_limit = i_ct_proglen;
                `PROGSEL_A0: run_limit = {1'b0, i_a0_proglen};
                default:     run_limit = 12'd0;
            endcase
        end
    endfunction

    function [11:0] full_limit;
        input [1:0] sel;
        begin
            case (sel)
                `PROGSEL_CM: full_limit = CM_WORDS;
                `PROGSEL_CT: full_limit = CT_WORDS;
                `PROGSEL_A0: full_limit = A0_WORDS;
                default:     full_limit = SHD_WORDS;
            endcase
        end
    endfunction

    function [11:0] section_addr;
        input [4:0] sec;
        input [11:0] idx;
        begin
            case (sec)
                SEC_SHD_PROG,
                SEC_SHD_CHK:      section_addr = `MEMSEL_SHD_START + idx;
                SEC_SHD_PROG_MASK,
                SEC_SHD_CHK_MASK: section_addr = `MEMSEL_SHD_MASK_START + idx;
                SEC_CM_CHK_MASK:  section_addr = `MEMSEL_CM_MASK_START + idx;
                SEC_CT_CHK_MASK:  section_addr = `MEMSEL_CT_MASK_START + idx;
                SEC_A0_CHK_MASK:  section_addr = `MEMSEL_A0_MASK_START + idx;
                default:          section_addr = idx;
            endcase
        end
    endfunction

    function [1:0] section_sel;
        input [4:0] sec;
        begin
            case (sec)
                SEC_CM_PROG,
                SEC_CM_CHK,
                SEC_CM_CHK_MASK: section_sel = `PROGSEL_CM;
                SEC_CT_PROG,
                SEC_CT_CHK,
                SEC_CT_CHK_MASK: section_sel = `PROGSEL_CT;
                SEC_A0_PROG,
                SEC_A0_CHK,
                SEC_A0_CHK_MASK: section_sel = `PROGSEL_A0;
                default:         section_sel = `PROGSEL_CM;
            endcase
        end
    endfunction

    function [4:0] next_rom_section;
        input [4:0] sec;
        begin
            case (sec)
                SEC_CM_PROG:       next_rom_section = SEC_CT_PROG;
                SEC_CT_PROG:       next_rom_section = SEC_A0_PROG;
                SEC_A0_PROG:       next_rom_section = SEC_SHD_PROG;
                SEC_SHD_PROG:      next_rom_section = SEC_SHD_PROG_MASK;
                SEC_SHD_PROG_MASK: next_rom_section = SEC_CM_CHK;
                SEC_CM_CHK:        next_rom_section = SEC_CT_CHK;
                SEC_CT_CHK:        next_rom_section = SEC_A0_CHK;
                SEC_A0_CHK:        next_rom_section = SEC_SHD_CHK;
                SEC_SHD_CHK:       next_rom_section = SEC_CM_CHK_MASK;
                SEC_CM_CHK_MASK:   next_rom_section = SEC_CT_CHK_MASK;
                SEC_CT_CHK_MASK:   next_rom_section = SEC_A0_CHK_MASK;
                SEC_A0_CHK_MASK:   next_rom_section = SEC_SHD_CHK_MASK;
                SEC_SHD_CHK_MASK:  next_rom_section = SEC_GPIO;
                SEC_GPIO:          next_rom_section = SEC_DONE;
                default:           next_rom_section = SEC_DONE;
            endcase
        end
    endfunction

    function [1:0] next_core_sel;
        input [1:0] sel;
        begin
            case (sel)
                `PROGSEL_CM: next_core_sel = `PROGSEL_CT;
                `PROGSEL_CT: next_core_sel = `PROGSEL_A0;
                default:     next_core_sel = `PROGSEL_IDLE;
            endcase
        end
    endfunction

    always @(posedge i_clk) begin
        if (i_rst) begin
            done_meta <= 3'b000;
            done_sync <= 3'b000;
        end else begin
            done_meta <= {i_a0_done, i_ct_done, i_cm_done};
            done_sync <= done_meta;
        end
    end

    always @(posedge i_clk) begin
        if (i_rst) begin
            state                         <= S_IDLE;
            section                       <= SEC_DONE;
            fast_run_pending              <= 1'b0;
            loading_shared                <= 1'b0;
            word_idx                      <= 12'h0;
            mask_word                     <= 32'h0;
            expected_word                 <= 32'h0;
            program_error_reg             <= 1'b0;
            program_sel_request            <= `PROGSEL_IDLE;
            cmduart_quiet_cycles           <= 0;
            program_sel_stable_cycles      <= 0;

            o_vscpu3x_program_sel         <= `PROGSEL_IDLE;
            o_test_running                <= 1'b0;
            o_a0_running                  <= 1'b0;
            o_ct_running                  <= 1'b0;
            o_cm_running                  <= 1'b0;
            o_memrw_error                 <= 1'b0;
            o_test_start                  <= 1'b0;

            o_gpio_mismatch_clr           <= 1'b0;
            o_gpio_pattern_len_update     <= 1'b0;
            o_gpio_pattern_len_update_data<= 8'h0;
            o_gpio_pattern_ren            <= 1'b0;
            o_gpio_pattern_wen            <= 3'b000;
            o_gpio_pattern_addr           <= 8'h0;
            o_gpio_pattern_input_data     <= 11'h0;
            o_gpio_pattern_output_chk_data<= 11'h0;
            o_gpio_pattern_output_act_data<= 11'h0;

            o_proglen_update              <= 1'b0;
            o_cm_proglen_update_data      <= 11'h0;
            o_ct_proglen_update_data      <= 12'h0;
            o_a0_proglen_update_data      <= 11'h0;

            o_progmem_valid               <= 1'b0;
            o_progmem_wen                 <= 1'b0;
            o_progmem_sel                 <= `PROGSEL_IDLE;
            o_progmem_addr                <= 12'h0;
            o_progmem_wdata               <= 32'h0;

            o_chkmem_mismatch_clr         <= 1'b0;
            o_chkmem_cm_mismatch_incr     <= 1'b0;
            o_chkmem_ct_mismatch_incr     <= 1'b0;
            o_chkmem_a0_mismatch_incr     <= 1'b0;
            o_chkmem_shd_mismatch_incr    <= 1'b0;
            o_chkmem_valid                <= 1'b0;
            o_chkmem_wen                  <= 1'b0;
            o_chkmem_sel                  <= `PROGSEL_IDLE;
            o_chkmem_addr                 <= 12'h0;
            o_chkmem_wdata                <= 32'h0;

            o_actmem_valid                <= 1'b0;
            o_actmem_sel                  <= `PROGSEL_IDLE;
            o_actmem_addr                 <= 12'h0;
            o_actmem_wdata                <= 32'h0;

            o_memrw_ready                 <= 1'b0;
            o_memrw_rdata                 <= 32'h0;

            o_progrom_ren                 <= 1'b0;
            o_progrom_sel                 <= `PROGSEL_IDLE;
            o_progrom_addr                <= 12'h0;
            o_chkrom_ren                  <= 1'b0;
            o_chkrom_sel                  <= `PROGSEL_IDLE;
            o_chkrom_addr                 <= 12'h0;
            o_gpio_rom_addr               <= 8'h0;

            o_cmduart_start               <= 1'b0;
            o_cmduart_wen                 <= 1'b0;
            o_cmduart_addr                <= 14'h0;
            o_cmduart_wdata               <= 32'h0;
        end else begin
            o_test_start               <= 1'b0;
            o_gpio_mismatch_clr        <= 1'b0;
            o_gpio_pattern_len_update  <= 1'b0;
            o_gpio_pattern_ren         <= 1'b0;
            o_gpio_pattern_wen         <= 3'b000;
            o_proglen_update           <= 1'b0;
            o_progmem_valid            <= 1'b0;
            o_chkmem_mismatch_clr      <= 1'b0;
            o_chkmem_cm_mismatch_incr  <= 1'b0;
            o_chkmem_ct_mismatch_incr  <= 1'b0;
            o_chkmem_a0_mismatch_incr  <= 1'b0;
            o_chkmem_shd_mismatch_incr <= 1'b0;
            o_chkmem_valid             <= 1'b0;
            o_actmem_valid             <= 1'b0;
            o_memrw_ready              <= 1'b0;
            o_memrw_error              <= 1'b0;
            o_progrom_ren              <= 1'b0;
            o_chkrom_ren               <= 1'b0;
            o_cmduart_start            <= 1'b0;

            if (i_cmduart_busy || o_cmduart_start || i_cmduart_done)
                cmduart_quiet_cycles <= 0;
            else if (!cmduart_margin_elapsed)
                cmduart_quiet_cycles <= cmduart_quiet_cycles + 1;

            if (!program_sel_margin_elapsed)
                program_sel_stable_cycles <= program_sel_stable_cycles + 1;

            if ((program_sel_request != o_vscpu3x_program_sel) &&
                cmduart_margin_elapsed && program_sel_margin_elapsed &&
                !i_cmduart_busy && !i_cmduart_done &&
                (!i_force_stop || (program_sel_request == `PROGSEL_CM))) begin
                o_vscpu3x_program_sel      <= program_sel_request;
                program_sel_stable_cycles <= 0;
            end

            if (i_program_error_clr)
                program_error_reg <= 1'b0;

            if (i_force_stop) begin
                program_sel_request   <= `PROGSEL_CM;
                o_test_running        <= 1'b0;
                o_a0_running          <= 1'b0;
                o_ct_running          <= 1'b0;
                o_cm_running          <= 1'b0;
                state                 <= S_IDLE;
            end else begin
                if ((state != S_IDLE) &&
                    (i_fetch_actmem || i_fetch_progmem || i_test_load_run || i_test_fast_run)) begin
                    program_error_reg <= 1'b1;
                end

                if ((state != S_IDLE) && i_memrw_valid) begin
                    o_memrw_error <= 1'b1;
                    o_memrw_ready <= 1'b1;
                end

                case (state)
                    S_IDLE: begin
                        if (i_memrw_valid) begin
                            if (i_memrw_sel == `PROGSEL_IDLE) begin
                                o_memrw_error <= 1'b1;
                                o_memrw_ready <= 1'b1;
                            end else begin
                                program_sel_request   <= i_memrw_sel;
                                state                 <= S_MEMRW_START;
                            end
                        end else if (i_fetch_actmem) begin
                            program_sel_request   <= `PROGSEL_CM;
                            o_progmem_sel         <= `PROGSEL_CM;
                            o_actmem_sel          <= `PROGSEL_CM;
                            word_idx              <= 12'h0;
                            state                 <= S_FETCH_SECTION;
                        end else if (i_fetch_progmem || i_test_fast_run) begin
                            fast_run_pending               <= i_test_fast_run;
                            section                        <= SEC_CM_PROG;
                            word_idx                       <= 12'h0;
                            o_cm_proglen_update_data       <= i_rom_cm_proglen;
                            o_ct_proglen_update_data       <= i_rom_ct_proglen;
                            o_a0_proglen_update_data       <= i_rom_a0_proglen;
                            o_gpio_pattern_len_update_data <= i_rom_gpio_pattern_len;
                            o_proglen_update               <= 1'b1;
                            o_gpio_pattern_len_update      <= 1'b1;
                            if (i_test_fast_run) begin
                                o_test_running             <= 1'b1;
                                o_a0_running               <= 1'b1;
                                o_ct_running               <= 1'b1;
                                o_cm_running               <= 1'b1;
                                o_gpio_mismatch_clr        <= 1'b1;
                                o_chkmem_mismatch_clr      <= 1'b1;
                            end
                            state                          <= S_ROM_SECTION;
                        end else if (i_test_load_run) begin
                            o_test_running       <= 1'b1;
                            o_a0_running         <= 1'b1;
                            o_ct_running         <= 1'b1;
                            o_cm_running         <= 1'b1;
                            o_gpio_mismatch_clr  <= 1'b1;
                            o_chkmem_mismatch_clr<= 1'b1;
                            o_progmem_sel        <= `PROGSEL_CM;
                            program_sel_request  <= `PROGSEL_CM;
                            loading_shared       <= 1'b0;
                            word_idx             <= 12'h0;
                            state                <= S_LOAD_SECTION;
                        end
                    end

                    S_ROM_SECTION: begin
                        if (section == SEC_DONE) begin
                            if (fast_run_pending) begin
                                fast_run_pending       <= 1'b0;
                                o_progmem_sel          <= `PROGSEL_CM;
                                program_sel_request    <= `PROGSEL_CM;
                                loading_shared         <= 1'b0;
                                word_idx               <= 12'h0;
                                state                  <= S_LOAD_SECTION;
                            end else begin
                                state <= S_IDLE;
                            end
                        end else if (section == SEC_GPIO) begin
                            if (word_idx < {4'h0, i_rom_gpio_pattern_len}) begin
                                if (i_gpio_pattern_ready) begin
                                    o_gpio_rom_addr                <= word_idx[7:0];
                                    o_gpio_pattern_addr            <= word_idx[7:0];
                                    state                          <= S_ROM_WRITE;
                                end
                            end else begin
                                section  <= next_rom_section(section);
                                word_idx <= 12'h0;
                            end
                        end else if ((section <= SEC_SHD_PROG_MASK) && (word_idx < prog_limit(section))) begin
                            if (i_progmem_ready) begin
                                o_progrom_ren   <= 1'b1;
                                o_progrom_sel   <= section_sel(section);
                                o_progrom_addr  <= section_addr(section, word_idx);
                                o_progmem_sel   <= section_sel(section);
                                o_progmem_addr  <= section_addr(section, word_idx);
                                state           <= S_ROM_WRITE;
                            end
                        end else if ((section >= SEC_CM_CHK) && (section <= SEC_SHD_CHK_MASK) &&
                                     (word_idx < chk_limit(section))) begin
                            if (i_chkmem_ready) begin
                                o_chkrom_ren    <= 1'b1;
                                o_chkrom_sel    <= section_sel(section);
                                o_chkrom_addr   <= section_addr(section, word_idx);
                                o_chkmem_sel    <= section_sel(section);
                                o_chkmem_addr   <= section_addr(section, word_idx);
                                state           <= S_ROM_WRITE;
                            end
                        end else begin
                            section  <= next_rom_section(section);
                            word_idx <= 12'h0;
                        end
                    end

                    S_ROM_WRITE: begin
                        if (section == SEC_GPIO) begin
                            if (i_gpio_pattern_ready) begin
                                o_gpio_pattern_input_data      <= i_gpio_rom_input_data;
                                o_gpio_pattern_output_chk_data <= i_gpio_rom_output_chk_data;
                                o_gpio_pattern_wen             <= 3'b011;
                                word_idx                       <= word_idx + 1'b1;
                                state                          <= S_ROM_SECTION;
                            end
                        end else if (section <= SEC_SHD_PROG_MASK) begin
                            if (i_progmem_ready) begin
                                o_progmem_valid <= 1'b1;
                                o_progmem_wen   <= 1'b1;
                                o_progmem_wdata <= i_progrom_rdata;
                                word_idx        <= word_idx + 1'b1;
                                state           <= S_ROM_SECTION;
                            end
                        end else begin
                            if (i_chkmem_ready) begin
                                o_chkmem_valid  <= 1'b1;
                                o_chkmem_wen    <= 1'b1;
                                o_chkmem_wdata  <= i_chkrom_rdata;
                                word_idx        <= word_idx + 1'b1;
                                state           <= S_ROM_SECTION;
                            end
                        end
                    end

                    S_LOAD_SECTION: begin
                        if (o_progmem_sel == `PROGSEL_IDLE) begin
                            o_progmem_sel          <= `PROGSEL_CM;
                            program_sel_request    <= `PROGSEL_CM;
                            word_idx               <= 12'h0;
                        end else if (word_idx < run_limit(o_progmem_sel)) begin
                            state <= S_LOAD_READ;
                        end else if (o_progmem_sel == `PROGSEL_A0) begin
                            o_progmem_sel          <= `PROGSEL_CM;
                            program_sel_request    <= `PROGSEL_CM;
                            loading_shared         <= 1'b1;
                            word_idx               <= 12'h0;
                            state                  <= S_LOAD_SHD_MASK;
                        end else begin
                            o_progmem_sel          <= next_core_sel(o_progmem_sel);
                            program_sel_request    <= next_core_sel(o_progmem_sel);
                            word_idx               <= 12'h0;
                        end
                    end

                    S_LOAD_READ: begin
                        if (i_progmem_ready) begin
                            o_progmem_valid <= 1'b1;
                            o_progmem_wen   <= 1'b0;
                            o_progmem_addr  <= word_idx;
                            state           <= S_LOAD_START;
                        end
                    end

                    S_LOAD_START: begin
                        if (~(i_cmduart_busy | o_progmem_valid) && program_sel_ready) begin
                            o_cmduart_start <= 1'b1;
                            o_cmduart_wen   <= 1'b1;
                            o_cmduart_addr  <= {2'b00, word_idx};
                            o_cmduart_wdata <= i_progmem_rdata;
                            state           <= S_LOAD_WAIT;
                        end
                    end

                    S_LOAD_WAIT: begin
                        if (i_cmduart_done) begin
                            if (i_cmduart_err) begin
                                program_error_reg       <= 1'b1;
                                program_sel_request     <= `PROGSEL_CM;
                                o_test_running          <= 1'b0;
                                o_a0_running            <= 1'b0;
                                o_ct_running            <= 1'b0;
                                o_cm_running            <= 1'b0;
                                state                   <= S_IDLE;
                            end else begin
                                word_idx <= word_idx + 1'b1;
                                state    <= (loading_shared) ? S_LOAD_SHD_MASK : S_LOAD_SECTION;
                            end
                        end
                    end

                    S_LOAD_SHD_MASK: begin
                        if (word_idx >= SHD_WORDS) begin
                            program_sel_request <= `PROGSEL_IDLE;
                            loading_shared      <= 1'b0;
                            if ((program_sel_request == `PROGSEL_IDLE) &&
                                (o_vscpu3x_program_sel == `PROGSEL_IDLE) &&
                                program_sel_margin_elapsed) begin
                                o_test_start <= 1'b1;
                                state        <= S_RUN;
                            end
                        end else if (i_progmem_ready) begin
                            o_progmem_valid <= 1'b1;
                            o_progmem_wen   <= 1'b0;
                            o_progmem_addr  <= `MEMSEL_SHD_MASK_START + {11'h0, word_idx[5]};
                            state           <= S_LOAD_SHD_MASK_WAIT;
                        end
                    end

                    S_LOAD_SHD_MASK_WAIT: begin
                        if (!o_progmem_valid) begin
                            mask_word <= i_progmem_rdata;
                            if (i_progmem_rdata[word_idx[4:0]])
                                state <= S_LOAD_SHD_READ;
                            else begin
                                word_idx <= word_idx + 1'b1;
                                state    <= S_LOAD_SHD_MASK;
                            end
                        end
                    end

                    S_LOAD_SHD_READ: begin
                        if (i_progmem_ready) begin
                            o_progmem_valid <= 1'b1;
                            o_progmem_wen   <= 1'b0;
                            o_progmem_addr  <= `MEMSEL_SHD_START + word_idx;
                            state           <= S_LOAD_SHD_READ_WAIT;
                        end
                    end

                    S_LOAD_SHD_READ_WAIT: begin
                            if (~(i_cmduart_busy | o_progmem_valid) && program_sel_ready) begin
                                o_cmduart_start <= 1'b1;
                                o_cmduart_wen   <= 1'b1;
                                o_cmduart_addr  <= `CMDUART_SHD_START + {8'h0, word_idx[5:0]};
                                o_cmduart_wdata <= i_progmem_rdata;
                                state           <= S_LOAD_WAIT;
                            end
                    end

                    S_RUN: begin
                        if (done_sync[0])
                            o_cm_running <= 1'b0;
                        if (done_sync[1])
                            o_ct_running <= 1'b0;
                        if (done_sync[2])
                            o_a0_running <= 1'b0;

                        if (!o_cm_running && !o_ct_running && !o_a0_running && i_test_driver_done) begin
                            program_sel_request   <= `PROGSEL_CM;
                            o_chkmem_sel          <= `PROGSEL_CM;
                            o_actmem_sel          <= `PROGSEL_CM;
                            word_idx              <= 12'h0;
                            state                 <= S_MASK_SECTION;
                        end
                    end

                    S_FETCH_SECTION: begin
                        if (word_idx < full_limit(o_actmem_sel)) begin
                            state <= S_FETCH_START;
                        end else if (o_actmem_sel == `PROGSEL_A0) begin
                            o_actmem_sel          <= `PROGSEL_IDLE;
                            program_sel_request   <= `PROGSEL_CM;
                            word_idx              <= 12'h0;
                            state                 <= S_FETCH_START;
                        end else if (o_actmem_sel == `PROGSEL_IDLE) begin
                            state <= S_IDLE;
                        end else begin
                            o_actmem_sel          <= next_core_sel(o_actmem_sel);
                            program_sel_request   <= next_core_sel(o_actmem_sel);
                            word_idx              <= 12'h0;
                        end
                    end

                    S_FETCH_START: begin
                        if (!i_cmduart_busy && program_sel_ready) begin
                            o_cmduart_start <= 1'b1;
                            o_cmduart_wen   <= 1'b0;
                            o_cmduart_addr  <= (o_actmem_sel == `PROGSEL_IDLE) ?
                                               (`CMDUART_SHD_START + {8'h0, word_idx[5:0]}) :
                                               {2'b00, word_idx};
                            state           <= S_FETCH_WAIT;
                        end
                    end

                    S_FETCH_WAIT: begin
                        if (i_cmduart_done) begin
                            if (i_cmduart_err) begin
                                program_error_reg     <= 1'b1;
                                program_sel_request   <= `PROGSEL_CM;
                                state                 <= S_IDLE;
                            end else if (i_actmem_ready) begin
                                o_actmem_valid <= 1'b1;
                                o_actmem_sel   <= o_actmem_sel;
                                o_actmem_addr  <= (o_actmem_sel == `PROGSEL_IDLE) ?
                                                  (`MEMSEL_SHD_START + word_idx) :
                                                  word_idx;
                                o_actmem_wdata <= i_cmduart_rdata;
                                if ((o_actmem_sel == `PROGSEL_IDLE) && (word_idx == SHD_WORDS - 1'b1)) begin
                                    state <= S_IDLE;
                                end else begin
                                    word_idx <= word_idx + 1'b1;
                                    state    <= S_FETCH_SECTION;
                                end
                            end
                        end
                    end

                    S_MASK_SECTION: begin
                        if (o_chkmem_sel == `PROGSEL_IDLE) begin
                            state <= S_MASK_READ;
                        end else if (word_idx < full_limit(o_chkmem_sel)) begin
                            state <= S_MASK_READ;
                        end else if (o_chkmem_sel == `PROGSEL_A0) begin
                            o_chkmem_sel          <= `PROGSEL_IDLE;
                            o_actmem_sel          <= `PROGSEL_IDLE;
                            program_sel_request   <= `PROGSEL_CM;
                            word_idx              <= 12'h0;


                            o_test_running        <= 1'b0;
                            state                 <= S_IDLE;
                        end else begin
                            o_chkmem_sel          <= next_core_sel(o_chkmem_sel);
                            o_actmem_sel          <= next_core_sel(o_chkmem_sel);
                            program_sel_request   <= next_core_sel(o_chkmem_sel);
                            word_idx              <= 12'h0;
                        end
                    end

                    S_MASK_READ: begin
                        if (word_idx >= full_limit(o_chkmem_sel)) begin
                            o_test_running <= 1'b0;
                            state          <= S_IDLE;
                        end else if (i_chkmem_ready) begin
                            o_chkmem_valid <= 1'b1;
                            o_chkmem_wen   <= 1'b0;
                            o_chkmem_sel   <= (o_chkmem_sel == `PROGSEL_IDLE) ? `PROGSEL_CM : o_chkmem_sel;
                            case (o_chkmem_sel)
                                `PROGSEL_CM:   o_chkmem_addr <= `MEMSEL_CM_MASK_START + {6'h0, word_idx[10:5]};
                                `PROGSEL_CT:   o_chkmem_addr <= `MEMSEL_CT_MASK_START + {6'h0, word_idx[10:5]};
                                `PROGSEL_A0:   o_chkmem_addr <= `MEMSEL_A0_MASK_START + {6'h0, word_idx[10:5]};
                                default:       o_chkmem_addr <= `MEMSEL_SHD_MASK_START + {11'h0, word_idx[5]};
                            endcase
                            state <= S_MASK_CHECK;
                        end
                    end

                    S_MASK_CHECK: begin
                        if (!o_chkmem_valid) begin
                            mask_word <= i_chkmem_rdata;
                            if (i_chkmem_rdata[word_idx[4:0]])
                                state <= S_MASK_EXPECT;
                            else begin
                                word_idx <= word_idx + 1'b1;
                                state    <= S_MASK_SECTION;
                            end
                        end
                    end

                    S_MASK_EXPECT: begin
                        if (i_chkmem_ready) begin
                            o_chkmem_valid <= 1'b1;
                            o_chkmem_wen   <= 1'b0;
                            o_chkmem_sel   <= (o_chkmem_sel == `PROGSEL_IDLE) ? `PROGSEL_CM : o_chkmem_sel;
                            o_chkmem_addr  <= (o_chkmem_sel == `PROGSEL_IDLE) ?
                                              (`MEMSEL_SHD_START + word_idx) :
                                              word_idx;
                            state          <= S_MASK_EXPECT_WAIT;
                        end
                    end

                    S_MASK_EXPECT_WAIT: begin
                        if (!o_chkmem_valid) begin
                            expected_word <= i_chkmem_rdata;
                            state         <= S_MASK_START;
                        end
                    end

                    S_MASK_START: begin
                        if (!i_cmduart_busy && program_sel_ready) begin
                            o_cmduart_start <= 1'b1;
                            o_cmduart_wen   <= 1'b0;
                            o_cmduart_addr  <= (o_chkmem_sel == `PROGSEL_IDLE) ?
                                               (`CMDUART_SHD_START + {8'h0, word_idx[5:0]}) :
                                               {2'b00, word_idx};
                            state           <= S_MASK_WAIT;
                        end
                    end

                    S_MASK_WAIT: begin
                        if (i_cmduart_done) begin
                            if (i_cmduart_err) begin
                                program_error_reg     <= 1'b1;
                                o_test_running        <= 1'b0;
                                program_sel_request   <= `PROGSEL_CM;
                                state                 <= S_IDLE;
                            end else if (i_actmem_ready) begin
                                o_actmem_valid <= 1'b1;
                                o_actmem_sel   <= (o_chkmem_sel == `PROGSEL_IDLE) ? `PROGSEL_CM : o_chkmem_sel;
                                o_actmem_addr  <= (o_chkmem_sel == `PROGSEL_IDLE) ?
                                                  (`MEMSEL_SHD_START + word_idx) :
                                                  word_idx;
                                o_actmem_wdata <= i_cmduart_rdata;

                                if (i_cmduart_rdata != expected_word) begin
                                    case (o_chkmem_sel)
                                        `PROGSEL_CM: o_chkmem_cm_mismatch_incr  <= 1'b1;
                                        `PROGSEL_CT: o_chkmem_ct_mismatch_incr  <= 1'b1;
                                        `PROGSEL_A0: o_chkmem_a0_mismatch_incr  <= 1'b1;
                                        default:     o_chkmem_shd_mismatch_incr <= 1'b1;
                                    endcase
                                end

                                word_idx <= word_idx + 1'b1;
                                state    <= S_MASK_SECTION;
                            end
                        end
                    end

                    S_MEMRW_START: begin
                        if (!i_cmduart_busy && program_sel_ready) begin
                            o_cmduart_start <= 1'b1;
                            o_cmduart_wen   <= i_memrw_wen;
                            o_cmduart_addr  <= {2'b00, i_memrw_addr};
                            o_cmduart_wdata <= i_memrw_wdata;
                            state           <= S_MEMRW_WAIT;
                        end
                    end

                    S_MEMRW_WAIT: begin
                        if (i_cmduart_done) begin
                            if (i_cmduart_err)
                                o_memrw_error <= 1'b1;
                            if (!i_memrw_wen)
                                o_memrw_rdata <= i_cmduart_rdata;
                            o_memrw_ready <= 1'b1;
                            state         <= S_IDLE;
                        end
                    end

                    default: begin
                        state <= S_IDLE;
                    end
                endcase
            end
        end
    end

endmodule
