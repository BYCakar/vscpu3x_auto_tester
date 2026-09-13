// Two-state functional equivalents for the SKY130 UDPs used by the supplied
// gate-level netlists. Verilator 5.020 cannot elaborate UDP tables. Compile
// this file before the PDK primitives.v so its per-primitive include guards
// select these models without changing the PDK or the standard-cell netlist.
//
// These models preserve the Boolean behavior and asynchronous set/reset of
// powered cells. They do not model notifier events, X propagation or timing
// checks. The surrounding PDK FUNCTIONAL cell models remain in use.
`timescale 1ns/1ps
`default_nettype none

`define SKY130_FD_SC_HD__UDP_DFF_P_PP_PG_N_V
module sky130_fd_sc_hd__udp_dff$P_pp$PG$N (
    output reg Q,
    input wire D, CLK, NOTIFIER, VPWR, VGND
);
    always @(posedge CLK or negedge VPWR or posedge VGND)
        if (!VPWR || VGND) Q <= 1'bx;
        else Q <= D;
endmodule

`define SKY130_FD_SC_HD__UDP_DFF_PR_PP_PG_N_V
module sky130_fd_sc_hd__udp_dff$PR_pp$PG$N (
    output reg Q,
    input wire D, CLK, RESET, NOTIFIER, VPWR, VGND
);
    always @(posedge CLK or posedge RESET or negedge VPWR or posedge VGND)
        if (!VPWR || VGND) Q <= 1'bx;
        else if (RESET) Q <= 1'b0;
        else Q <= D;
endmodule

`define SKY130_FD_SC_HD__UDP_DFF_PS_PP_PG_N_V
module sky130_fd_sc_hd__udp_dff$PS_pp$PG$N (
    output reg Q,
    input wire D, CLK, SET, NOTIFIER, VPWR, VGND
);
    always @(posedge CLK or posedge SET or negedge VPWR or posedge VGND)
        if (!VPWR || VGND) Q <= 1'bx;
        else if (SET) Q <= 1'b1;
        else Q <= D;
endmodule

`define SKY130_FD_SC_HD__UDP_MUX_2TO1_V
module sky130_fd_sc_hd__udp_mux_2to1 (
    output wire X,
    input wire A0, A1, S
);
    assign X = S ? A1 : A0;
endmodule

`define SKY130_FD_SC_HD__UDP_MUX_4TO2_V
module sky130_fd_sc_hd__udp_mux_4to2 (
    output wire X,
    input wire A0, A1, A2, A3, S0, S1
);
    assign X = S1 ? (S0 ? A3 : A2) : (S0 ? A1 : A0);
endmodule

`define SKY130_FD_SC_HD__UDP_PWRGOOD_PP_G_V
module sky130_fd_sc_hd__udp_pwrgood_pp$G (
    output wire UDP_OUT,
    input wire UDP_IN, VGND
);
    assign UDP_OUT = !VGND ? UDP_IN : 1'bx;
endmodule

`define SKY130_FD_SC_HD__UDP_PWRGOOD_PP_P_V
module sky130_fd_sc_hd__udp_pwrgood_pp$P (
    output wire UDP_OUT,
    input wire UDP_IN, VPWR
);
    assign UDP_OUT = VPWR ? UDP_IN : 1'bx;
endmodule

`define SKY130_FD_SC_HD__UDP_PWRGOOD_PP_PG_V
module sky130_fd_sc_hd__udp_pwrgood_pp$PG (
    output wire UDP_OUT,
    input wire UDP_IN, VPWR, VGND
);
    assign UDP_OUT = (VPWR && !VGND) ? UDP_IN : 1'bx;
endmodule

`default_nettype wire
