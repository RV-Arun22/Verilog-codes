//testbench file for the 16:1 mux hierarchial design

`include "mux16to1.v"
`timescale 10ns/1ns

module mux16to1_tb;
    reg [15:0] ins;
    reg [3:0] ctrl;
    wire y;

    _16to1mux M1 (ins,ctrl,y);
    initial 
        begin
        $dumpfile("mux16to1.vcd");

        $dumpvars(0, mux16to1_tb);  //use the name of the testbench module, not the file name

        ins = 16'h30cf;             //inputs to the 16 lines of the mux : 0011 0000 1100 1111
        #2
        ctrl = 4'h0;
        #2
        ctrl = 4'h1;
        #2
        ctrl = 4'h2;
        #2
        ctrl = 4'h3;
        #2
        ctrl = 4'h4;
        #2
        ctrl = 4'h5;
        #2
        ctrl = 4'h6;
        #2
        ctrl = 4'h7;
        #2
        ctrl = 4'h8;
        #2
        ctrl = 4'h9;
        #2
        ctrl = 4'ha;
        #2
        ctrl = 4'hb;
        #2
        ctrl = 4'hc;
        #2
        ctrl = 4'hd;
        #2
        ctrl = 4'he;
        #2
        ctrl = 4'hf;
        #2
        ctrl = 4'hf;
        end
endmodule