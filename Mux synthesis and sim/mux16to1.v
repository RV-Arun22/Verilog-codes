`include "mux4to1.v"
module _16to1mux(in,sel,out);
    input [15:0] in;
    input [3:0] sel;
    output out;
    wire [3:0] t;

    mux4to1 M1 (t[0],sel[1:0],in[3:0]);
    mux4to1 M2 (t[1],sel[1:0],in[7:4]);
    mux4to1 M3 (t[2],sel[1:0],in[11:8]);
    mux4to1 M4 (t[3],sel[1:0],in[15:12]);
    mux4to1 M5 (out,sel[3:2],t[3:0]);
    
endmodule