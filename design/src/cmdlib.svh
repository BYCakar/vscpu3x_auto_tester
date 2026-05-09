`ifndef CMDLIB_VH
`define CMDLIB_VH

localparam CHAR_W = 8'h57;
localparam CHAR_R = 8'h52;
localparam CHAR_0 = 8'h30;
localparam CHAR_9 = 8'h39;
localparam CHAR_A = 8'h41;
localparam CHAR_F = 8'h46;

function [7:0] hex2char;
    input [3:0] hex;
    begin
        hex2char = (hex >= 4'h0 && hex <= 4'h9) ? hex + CHAR_0 : hex - 10 + CHAR_A;
    end
endfunction

function [3:0] char2hex;
    input [7:0] char;
    begin
        char2hex = (char >= CHAR_0 && char <= CHAR_9) ? char - CHAR_0 : char - CHAR_A + 10;
    end
endfunction

function [0:4][7:0] to_rdcmd;
    input [15:0] addr;
    begin
        integer i;

        to_rdcmd[0] = CHAR_R;

        for (i = 0; i < 4; i = i+1)
            to_rdcmd[4-i] = hex2char(addr[i*4+:4]);
    end
endfunction

function [0:8][7:0] to_wrcmd;
    input [31:0] data;
    begin
        integer i;

        to_wrcmd[0] = CHAR_W;

        for (i = 0; i < 8; i = i+1)
            to_wrcmd[8-i] = hex2char(data[i*4+:4]);
    end
endfunction

function [31:0] to_rdata;
    input [0:7][7:0] str_rdata;
    begin
        integer i;
        
        for (i = 0; i < 8; i = i+1)
            to_rdata[i*4+:4] = char2hex(str_rdata[7-i]);
    end 
endfunction

`endif