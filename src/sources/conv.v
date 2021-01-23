module conv(
input clk,
input ready,
input [7:0] fifo1_data_i,
input [7:0] fifo2_data_i,
input [7:0] fifo3_data_i,
output reg [15:0] data_o,
output reg done
);

reg [7:0] buffer1 [2:0];
reg [7:0] buffer2 [2:0];
reg [7:0] buffer3 [2:0];
reg [3:0] count = 4'b0000;

initial begin
  done <= 1'b0;
  data_o <= 8'b0000_0000;
end

always @(posedge clk) begin
  if (ready == 1) begin
    buffer1[count] <= fifo1_data_i;
    buffer2[count] <= fifo2_data_i;
    buffer3[count] <= fifo3_data_i;
    count = count + 4'b0001;
  end
  if (count == 4'b0011) begin
      count = 4'b0000;
      done <= 1'b1;
  end
  if (done) begin
      data_o <= ((buffer1[2]  - buffer1[0]) + ((buffer2[2] * 2) - (buffer2[0] * 2)) + (buffer3[2]  - buffer3[0] ));
      done <= 1'b0;
    end
end
endmodule
