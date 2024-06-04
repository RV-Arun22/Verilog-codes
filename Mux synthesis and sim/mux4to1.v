//4:1 mux module for 16:1 hierarchial model
`include "mux2to1.v"
module mux4to1(out,sel,in);
    input [3:0] in;
    input [1:0] sel;
    output out;
    wire [1:0] t; 

    mux2to1 M1 (t[0],sel[0],in[1:0]);
    mux2to1 M2 (t[1],sel[0],in[3:2]);
    mux2to1 M3 (out,sel[1],t[1:0]);
    //assign out = in[sel];
endmodule