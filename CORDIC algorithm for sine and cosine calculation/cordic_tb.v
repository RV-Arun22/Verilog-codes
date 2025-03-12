`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BITS Pilani
// Engineer: Me
// 
// Create Date: 03/11/2025 01:59:05 PM
// Design Name: 
// Module Name: cordic_tb
// Project Name: CORDIC algorithm ckt to calculate sine and cosine values
// Target Devices: Zynq 7000
// Tool Versions: 
// Description: Testbench for the main circuit
// 
// Dependencies: cordic.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_tb();
    reg clk, rst, start;
    reg [15:0] angle;       //given in radians in 2.14 fixed point format
    wire done; 
    wire [2:0] state;
    wire [15:0] sine,cosine;
    
    cordic calc (angle, clk, rst, start, done, sine, cosine, state);
    
    always #5 clk = ~clk;
    
    initial 
        begin
            clk = 1'b0; rst = 1'b1; start = 1'b0; angle = 16'd0;
            #9 rst = 1'b0; 
            //#3 start = 1'b1; angle = 16'b0110010001111011;  //90deg = pi/2 rad = 1.57 rad
            //#3 start = 1'b1; angle = 16'b0100001100000101;    //60deg = pi/3 rad = 1.047197 rad
            //#3 start = 1'b1; angle = 16'b0011001001000100;    //45deg = pi/4 rad = 0.78539 rad
            //#3 start = 1'b1; angle = 16'b0010000110000011;    //30deg = pi/6 rad = 0.523598 rad
            #3 start = 1'b1; angle = 16'd0;     //0 deg = 0 rad
            #5 start = 1'b0;
            #350 $finish;
        end
    
endmodule