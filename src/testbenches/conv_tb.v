`include "conv.v"
module conv_tb();
reg clk;
reg ready;
reg [7:0] fifo1_data_i;
reg [7:0] fifo2_data_i;
reg [7:0] fifo3_data_i;
wire [7:0] data_o;
wire done;
wire done_o;

conv MyConv(.clk(clk), .ready(ready), .fifo1_data_i(fifo1_data_i), .fifo2_data_i(fifo2_data_i), .fifo3_data_i(fifo3_data_i), .data_o(data_o), .done(done), .done_o(done_o));

initial begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
  ready = 1;
  fifo1_data_i = 8'b0000_0000;
	fifo2_data_i = 8'b0000_0011;
	fifo3_data_i = 8'b0000_0100;
end

always @(posedge clk) begin
  fifo1_data_i = fifo1_data_i + 8'b0000_0001;
	fifo2_data_i = fifo2_data_i + 8'b0000_0001;
	fifo3_data_i = fifo3_data_i + 8'b0000_0001;
	if (done_o) begin
		$finish;
	end
	$dumpfile("conv.vcd");
  $dumpvars(0, conv_tb);
end
endmodule
