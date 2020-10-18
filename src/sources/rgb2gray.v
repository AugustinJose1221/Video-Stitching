`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2020 13:14:01
// Design Name: 
// Module Name: rgb2gray
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb2gray(
    input clk,
    input rst,
    
    input [7:0] red_i,
    input [7:0] green_i,
    input [7:0] blue_i,
    
    input done_i,
    
    output reg [7:0] grayscale_o,
    output reg [7:0] done_o
    );
    
    always @(posedge clk) begin
        done_o <= 1'b1;
        if (rst) begin
            grayscale_o <= 8'b0000_0000;
            done_o <= 1'b0;
        end
        else begin
            if (done_i == 1) begin
                grayscale_o <= (red_i>>2)+(red_i>>5)+(green_i>>1)+(green_i>>4)+(blue_i>>4)  + (blue_i>>5);
                done_o <= 1'b1;
            end
            else begin
                grayscale_o <= 0;
                done_o <= 0;
            end
         end
     end
endmodule
