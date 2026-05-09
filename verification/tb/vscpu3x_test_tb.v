`timescale 1ns/1ps

module vscpu3x_test_tb ();

reg vscpu3x_clk = 0;
reg vscpu3x_rst = 1;

reg dut_clk = 0;
reg dut_rst = 1;

reg [1:0] program_sel = 0;

wire [`MPRJ_IO_PADS-1:0] vscpu3x_io_out, vscpu3x_io_oenb, vscpu3x_io_in, vscpu3x_io_pads;
wire [`MPRJ_IO_PADS-1:0] dut_io_out, dut_io_oen, dut_io_in;

wire modbus_tx, modbus_rx;

always #50 vscpu3x_clk = ~vscpu3x_clk;
always #10 dut_clk = ~dut_clk;

initial #1000 vscpu3x_rst = 0;
initial #1000 dut_rst = 0;

genvar i;
generate
    for (i = 0; i < `MPRJ_IO_PADS; i = i + 1) begin
        assign vscpu3x_io_pads[i] = (vscpu3x_io_oenb[i]) ? 1'bz : vscpu3x_io_out[i];
        assign vscpu3x_io_in[i] = vscpu3x_io_pads[i];
    
        assign vscpu3x_io_pads[i] = (dut_io_oen[i]) ? dut_io_out[i] : 1'bz;
        assign dut_io_in[i] = vscpu3x_io_pads[i];
    end    
endgenerate

user_project_wrapper vscpu3x(
    .wb_clk_i(vscpu3x_clk),
    .wb_rst_i(1'b0),
    .wbs_stb_i(1'b0),
    .wbs_cyc_i(1'b0),
    .wbs_we_i(1'b0),
    .wbs_sel_i(4'h0),
    .wbs_dat_i(32'h0),
    .wbs_adr_i(32'h0),
    .wbs_ack_o(),
    .wbs_dat_o(),

    .la_data_in(),
    .la_data_out(),
    .la_oenb(),

    .io_in(vscpu3x_io_in),
    .io_out(vscpu3x_io_out),
    .io_oeb(vscpu3x_io_oenb),

    .analog_io(),

    .user_clock2(1'b0),

    .user_irq()
);

vscpu3x_test_top dut(
    .i_clk(dut_clk),
    .i_rst(dut_rst),

    .i_modbus_rx(modbus_rx),
    .o_modbus_tx(modbus_tx),

    .i_vscpu3x_io_in(dut_io_in),
    .o_vscpu3x_io_out(dut_io_out),
    .o_vscpu3x_io_oen(dut_io_oen)
);

dpi_uart modbus_if(
  .rst_i(dut_rst),
  .clk_i(dut_clk),

  .uart_rx_i(modbus_tx),
  .uart_tx_o(modbus_rx),

  .divisor_i(1)
);

/*uart_dpi #(
  .CLOCK_HZ(50_000_000),
  .BAUD(115200)
)(
    .clk(dut_clk),
    .rst_n(~dut_rst),

    .rx_i(modbus_tx),   // from DUT (DUT TX) -> we sample this
    .tx_o(modbus_rx)    // to DUT   (DUT RX) <- we drive this
);*/

string memfile_prefix;
string cm_memfile_0, cm_memfile_1, cm_memfile_2, cm_memfile_3;
string ct_memfile_0, ct_memfile_1, ct_memfile_2, ct_memfile_3, ct_memfile_4;
string a0_memfile_0, a0_memfile_1, a0_memfile_2;

`ifdef VSCPU_MEM_INIT

initial begin
    if (!$value$plusargs("VSCPU_MEM_INIT_FILE_PREFIX=%s", memfile_prefix)) begin
        $display("No VSCPU_MEM_INIT_FILE specified");
        memfile_prefix = "";
    end

    cm_memfile_0 = {memfile_prefix, "_cm_0.mem"};
    cm_memfile_1 = {memfile_prefix, "_cm_1.mem"};
    cm_memfile_2 = {memfile_prefix, "_cm_2.mem"};
    cm_memfile_3 = {memfile_prefix, "_cm_3.mem"};
    ct_memfile_0 = {memfile_prefix, "_ct_0.mem"};
    ct_memfile_1 = {memfile_prefix, "_ct_1.mem"};
    ct_memfile_2 = {memfile_prefix, "_ct_2.mem"};
    ct_memfile_3 = {memfile_prefix, "_ct_3.mem"};
    ct_memfile_4 = {memfile_prefix, "_ct_4.mem"};
    a0_memfile_0 = {memfile_prefix, "_a0_0.mem"};
    a0_memfile_1 = {memfile_prefix, "_a0_1.mem"};
    a0_memfile_2 = {memfile_prefix, "_a0_2.mem"};

    $readmemh(cm_memfile_0, vscpu3x.codemaker_sram2k_inst0.mem);
    $readmemh(cm_memfile_1, vscpu3x.codemaker_sram2k_inst1.mem);
    $readmemh(cm_memfile_2, vscpu3x.codemaker_sram2k_inst2.mem);
    $readmemh(cm_memfile_3, vscpu3x.codemaker_sram2k_inst3.mem);
    $readmemh(ct_memfile_0, vscpu3x.control_tower_sram2k_inst0.mem);
    $readmemh(ct_memfile_1, vscpu3x.control_tower_sram2k_inst1.mem);
    $readmemh(ct_memfile_2, vscpu3x.control_tower_sram2k_inst2.mem);
    $readmemh(ct_memfile_3, vscpu3x.control_tower_sram2k_inst3.mem);
    $readmemh(ct_memfile_4, vscpu3x.control_tower_sram2k_inst4.mem);
    $readmemh(a0_memfile_0, vscpu3x.agent_1_sram2k_inst0.mem);
    $readmemh(a0_memfile_1, vscpu3x.agent_1_sram2k_inst1.mem);
    $readmemh(a0_memfile_2, vscpu3x.agent_1_sram2k_inst2.mem);
end

`endif

endmodule