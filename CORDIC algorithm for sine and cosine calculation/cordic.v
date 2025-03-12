`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BITS Pilani
// Engineer: Me
// 
// Create Date: 02/27/2025 02:49:39 PM
// Design Name: 
// Module Name: cordic
// Project Name: CORDIC algorithm ckt to calculate sine and cosine values
// Target Devices: Zynq 7000
// Tool Versions: 
// Description: RTL (Moore FSM based) description of the CORDIC sine/cosine calculator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic(
    input signed [15:0] angle,         //Input angle in radians in 2.14 fixed-point format
    input clk, rst, start,      //start is made 1 after input is ready to be given
    output reg done,
    output reg signed [15:0] sine, cosine,
    output reg [2:0] state
    );
    
    parameter S0= 3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4 = 3'd4;  //states
    integer i;                                                 //Iteration count variable
    
    //reg [2:0] state;
    reg signed [15:0] atan_val [15:0];
    reg signed [15:0] x, y; 
    reg signed [15:0] alpha; 

    
    initial
        begin   //alpha values such that arctan(alpha) = 2^-i
            atan_val[0] = 16'b0011001001000100;
            atan_val[1] = 16'b0001110110101100;
            atan_val[2] = 16'b0000111110101110;
            atan_val[3] = 16'b0000011111110101;
            atan_val[4] = 16'b0000001111111111;
            atan_val[5] = 16'b0000001000000000;
            atan_val[6] = 16'b0000000100000000;
            atan_val[7] = 16'b0000000010000000;
            atan_val[8] = 16'b0000000001000000;
            atan_val[9] = 16'b0000000000100000;
            atan_val[10] = 16'b0000000000010000;
            atan_val[11] = 16'b0000000000001000;
            atan_val[12] = 16'b0000000000000100;
            atan_val[13] = 16'b0000000000000010;
            atan_val[14] = 16'b0000000000000001;
            atan_val[15] = 16'b0000000000000000;
        end
        
//State change block      
    always @ (posedge clk)                          
        begin
            if (rst == 1'b1)
                begin               
                    state = S0; 
                end
            else
                begin
                    case (state)
                        S0: if (start == 1'b1) state <= S1;
                            else state <= S0;
                        S1: if (i < 16)
                                begin
                                    if (angle >= alpha) state <= S2;    //increment alpha
                                    else state <= S3;                   //decrement alpha
                                end
                            else state <= S4;        //exit loop
                        S2: state <= S1;
                        S3: state <= S1;
                        S4: if (start == 1'b0) state <= S4;    //hold result state if start=0
                            else state <= S0;               //else process next input 
                        default: state <= S0; 
                    endcase
                end 
        end
        
//Output change block    
    always @ (state)                                
        begin
            case (state)
                S0: begin x <= 'b00_10011011010111;  //Amplification factor
                          y <= 'd0; 
                          alpha <= 'd0; done <= 1'b0; i <= 0;
                    end
                S1: begin end
                S2: begin
                        x <= x - (y>>>i);
                        y <= y + (x>>>i);
                        alpha <= alpha + atan_val[i];
                        i <= i + 1;
                    end                         
                S3: begin
                        x <= x + (y>>>i);
                        y <= y - (x>>>i);
                        alpha <= alpha - atan_val[i];
                        i <= i + 1;
                    end                     
                S4: begin
                        done <= 1'b1;
                        sine <= y;
                        cosine <= x;
                    end          
            endcase 
        end 
    
endmodule