`include "hold.v"
`include "Fifo.v"
`include "conv.v"

module fifo_conv_top(
input clk,
input data_valid,
input [7:0] data_i,

output wire idle,
output wire done,
output wire [15:0] data_o,
output wire conv_done
);

wire [7:0] fifo1_data_o;
wire [7:0] fifo2_data_o;
wire [7:0] fifo3_data_o;
wire [7:0] fifo1_data_i;
wire [7:0] fifo2_data_i;
wire [7:0] fifo3_data_i;
wire ready;
wire idle_o;
wire ready_o;
wire done_o;


Fifo myFifo(.clk(clk), .data_valid(data_valid), .data_i(data_i), .fifo1_data_o(fifo1_data_i), .fifo2_data_o(fifo2_data_i), .fifo3_data_o(fifo3_data_i), .idle(idle), .idle_i(idle_o), .ready(ready), .done(done), .done_i(done_o));

hold myHold(.clk(clk), .fifo1_data_i(fifo1_data_i), .fifo2_data_i(fifo2_data_i), .fifo3_data_i(fifo3_data_i), .fifo1_data_o(fifo1_data_o), .fifo2_data_o(fifo2_data_o), .fifo3_data_o(fifo3_data_o), .ready_i(ready), .idle_o(idle_o), .ready_o(ready_o), .done_o(done_o));

conv myConv(.clk(clk), .ready(ready_o), .fifo1_data_i(fifo1_data_o), .fifo2_data_i(fifo2_data_o), .fifo3_data_i(fifo3_data_o), .data_o(data_o), .done(conv_done));

endmodule
