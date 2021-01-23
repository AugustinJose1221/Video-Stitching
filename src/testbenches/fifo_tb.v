`include "Fifo.v"
module fifo_tb();
reg clk;
reg data_valid;
reg [7:0] data_i;
reg [7:0] mem [24:0];
reg [7:0] i;

wire [7:0] fifo1_data_o;
wire [7:0] fifo2_data_o;
wire [7:0] fifo3_data_o;
wire idle;
wire ready;
wire done;

Fifo myFifo(.clk(clk), .data_valid(data_valid), .data_i(data_i), .fifo1_data_o(fifo1_data_o), .fifo2_data_o(fifo2_data_o), .fifo3_data_o(fifo3_data_o), .idle(idle), .ready(ready), .done(done));

initial begin
  clk = 1'b0;
  forever #5 clk = ~clk;
end

initial begin
  data_valid = 1'b0;
  data_i = 8'b0000_0000;
  i = 8'b0000_0000;
  $readmemh("data.txt", mem);
end

always @(posedge clk) begin
  #10
  if (idle) begin
    $display("%h %b", mem[i], i);
    data_valid = 1'b1;
    data_i = mem[i];
    i = i + 8'b0000_0001;
    if (i== 8'b0001_1010) begin
      data_i = 8'b0000_0000;
    end
    if (done) begin
      $finish;
    end
  end
  else begin
    data_valid = 1'b0;
  end
  $dumpfile("Fifo.vcd");
  $dumpvars(0, fifo_tb);
end
endmodule
