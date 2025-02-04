`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arun
// 
// Create Date: 01/23/2025 01:42:32 PM
// Design Name: Carry select adder, also known as redundant carry adder
// Module Name: carry_select_adder_signed_32bit
// Project Name: Carry select adder, also known as redundant carry adder
// Target Devices: 
// Tool Versions: 
// Description: 32-bit carry select adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module carry_select_adder_signed_32bit(
    input [31:0] a,b,
    input cin,
    output [31:0] sum,
    output zero_flag,
    output cout
    );
    wire [4:1] block_carry;
    wire [6:1] inter_carry;
    wire [31:8] inter_sum0, inter_sum1;
    //FIrst 8-bit RCA
    RCA_8bit m0 (a[7:0], b[7:0], cin, sum[7:0], block_carry[1]);
    //Block 1
    RCA_8bit m10 (a[15:8], b[15:8], 1'b0, inter_sum0[15:8], inter_carry[1]);
    RCA_8bit m11 (a[15:8], b[15:8], 1'b1, inter_sum1[15:8], inter_carry[2]);
    //Block 2
    RCA_8bit m20 (a[23:16], b[23:16], 1'b0, inter_sum0[23:16], inter_carry[3]);
    RCA_8bit m21 (a[23:16], b[23:16], 1'b1, inter_sum1[23:16], inter_carry[4]);
    //Block 3 - final block
    RCA_8bit m30 (a[31:24], b[31:24], 1'b0, inter_sum0[31:24], inter_carry[5]);
    RCA_8bit m31 (a[31:24], b[31:24], 1'b1, inter_sum1[31:24], inter_carry[6]);
    
    //carry mux selections
    mux_2x1_1w mxc1 (block_carry[1], inter_carry[1],inter_carry[1], block_carry[2]);
    mux_2x1_1w mxc2 (block_carry[2], inter_carry[3],inter_carry[4], block_carry[3]);
    mux_2x1_1w mxc3 (block_carry[3], inter_carry[5],inter_carry[6], block_carry[4]);
    
    //sum mux selections
    mux_2x1_8w mxs1 (block_carry[1], inter_sum0[15:8], inter_sum1[15:8], sum[15:8]);
    mux_2x1_8w mxs2 (block_carry[2], inter_sum0[23:16], inter_sum1[23:16], sum[23:16]);
    mux_2x1_8w mxs3 (block_carry[3], inter_sum0[31:24], inter_sum1[31:24], sum[31:24]);
    
    //Zero flag assignment
    assign zero_flag = ~|sum;
    assign cout = block_carry[4];
    
endmodule


module RCA_8bit(
    input [7:0] a,b,
    input cin, 
    output reg [7:0] sum,
    output cout
    );
    reg [8:0] c;                //intermediate carry wires
    integer i;
    always @ (*)
        begin
            c[0] = cin;
            for (i = 0; i < 8; i = i + 1)
                begin
                    sum[i] = a[i] ^ b[i] ^ c[i];
                    c[i+1] = (a[i] & b[i]) | (b[i] & c[i]) | (c[i] & a[i]);
                end     
            
//            if ((a[31] & b[31] & ~c[32]) == 1'b1)
//                begin 
//                    overflow = 1'b1;  
//                end     
//            else if ((~a[31] & ~b[31] & c[32]) == 1'b1)
//                begin 
//                    overflow = 1'b1;  
//                end      
//            else 
//                    overflow = 1'b0;                        
        end       
        assign cout = c[8]; 
endmodule


module mux_2x1_8w (                 //2x1 mux with 8-bit bus width
    input sel,
    input [7:0] a,b,
    output reg [7:0] y   
    );
    always @ (*)
        begin
            if (sel == 1'b0) 
                y = a;
            else 
                y = b;
        end        
endmodule

module mux_2x1_1w (                 //2x1 mux with 1-bit bus width
    input sel,
    input a,b,
    output reg y   
    );
    always @ (*)
        begin
            if (sel == 1'b0) 
                y = a;
            else 
                y = b;
        end        
endmodule   
