`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2020 15:03:31
// Design Name: 
// Module Name: read_write_tb
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

`define clk_period 10

module read_write_tb();
reg clk, rst;
reg done_i;
reg [7:0] red_i, green_i, blue_i;
wire [7:0] grayscale_o;
wire done_o;
reg [15:0] mem[12287:0];
integer i;
integer file_id;


rgb2gray RGB2GRAY(
    clk,
    rst,
    red_i,
    green_i,
    blue_i,
    done_i,
    grayscale_o,
    done_o
    );
    
initial clk = 1'b1;
always #(`clk_period/2) clk = ~clk;


initial begin
    $readmemh("D:\\Projects\\Verilog\\ImageProcessingTest\\data.txt", mem);
    #(`clk_period);
    rst = 1'b0;
    done_i = 1'b1;
    for(i=0; i<(12288/3);i=i+1)
    begin
        #(`clk_period);
        red_i = mem[3*i];
        green_i = mem[(3*i)+1];
        blue_i = mem[(3*i)+2];
        done_i = 1'b1;
    end
    #(`clk_period);
    done_i = 1'b0;
    $finish;
 end
 always @(posedge clk) begin
    file_id = $fopen("D:\\Projects\\Verilog\\ImageProcessingTest\\out.txt","a");
    $fwrite(file_id, "%h\n", grayscale_o);
    $fclose(file_id);        
end
endmodule
