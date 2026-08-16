`include "Modbus_Regspace_defines.vh"

module test_rom #(
    parameter integer TEST_COUNT = 10
) (
    input               i_clk,
    input               i_rst,
    input       [3:0]   i_testnum,

    output reg  [10:0]  o_cm_proglen,
    output reg  [11:0]  o_ct_proglen,
    output reg  [10:0]  o_a0_proglen,
    output reg  [7:0]   o_gpio_pattern_len,

    input               i_progmem_ren,
    input       [1:0]   i_progmem_sel,
    input       [11:0]  i_progmem_addr,
    output reg  [31:0]  o_progmem_rdata,

    input               i_chkmem_ren,
    input       [1:0]   i_chkmem_sel,
    input       [11:0]  i_chkmem_addr,
    output reg  [31:0]  o_chkmem_rdata,

    input       [7:0]   i_gpio_pattern_addr,
    output      [10:0]  o_gpio_pattern_input_data,
    output      [10:0]  o_gpio_pattern_output_chk_data
);

    reg [10:0] cm_proglen_table [0:TEST_COUNT-1];
    reg [11:0] ct_proglen_table [0:TEST_COUNT-1];
    reg [10:0] a0_proglen_table [0:TEST_COUNT-1];
    reg [7:0]  gpio_len_table   [0:TEST_COUNT-1];

    integer i;

    initial begin
        for (i = 0; i < TEST_COUNT; i = i + 1) begin
            cm_proglen_table[i] = 11'h0;
            ct_proglen_table[i] = 12'h0;
            a0_proglen_table[i] = 11'h0;
            gpio_len_table[i]   = 8'h0;
        end
    end

    always @* begin
        if (i_testnum < TEST_COUNT) begin
            o_cm_proglen       = cm_proglen_table[i_testnum];
            o_ct_proglen       = ct_proglen_table[i_testnum];
            o_a0_proglen       = a0_proglen_table[i_testnum];
            o_gpio_pattern_len = gpio_len_table[i_testnum];
        end else begin
            o_cm_proglen       = 11'h0;
            o_ct_proglen       = 12'h0;
            o_a0_proglen       = 11'h0;
            o_gpio_pattern_len = 8'h0;
        end
    end

    always @* begin
        o_progmem_rdata = 32'h0;
        casez (i_progmem_addr)
            `MEMSEL_SHD_MASK: o_progmem_rdata = 32'h0;
            `MEMSEL_SHD:      o_progmem_rdata = 32'h0;
            default: begin
                case (i_progmem_sel)
                    `PROGSEL_CM,
                    `PROGSEL_CT,
                    `PROGSEL_A0: o_progmem_rdata = 32'h0;
                    default:     o_progmem_rdata = 32'h0;
                endcase
            end
        endcase
    end

    always @* begin
        o_chkmem_rdata = 32'h0;
        casez (i_chkmem_addr)
            `MEMSEL_CM_MASK,
            `MEMSEL_CT_MASK,
            `MEMSEL_A0_MASK,
            `MEMSEL_SHD_MASK,
            `MEMSEL_SHD: o_chkmem_rdata = 32'h0;
            default: begin
                case (i_chkmem_sel)
                    `PROGSEL_CM,
                    `PROGSEL_CT,
                    `PROGSEL_A0: o_chkmem_rdata = 32'h0;
                    default:     o_chkmem_rdata = 32'h0;
                endcase
            end
        endcase
    end

    assign o_gpio_pattern_input_data      = 11'h0;
    assign o_gpio_pattern_output_chk_data = 11'h0;

endmodule
