module Fifo(
input clk,
input data_valid,
input [7:0] data_i,
input idle_i,
input done_i,

output reg [7:0] fifo1_data_o,
output reg [7:0] fifo2_data_o,
output reg [7:0] fifo3_data_o,
output reg idle,
output reg ready,
output reg done
);

parameter WIDTH = 5; // Width of the image
parameter HEIGHT = 5; // Height of the image
integer i;

reg MODE; // Read/Write Mode
reg [7:0] R_COUNT;  // Read Counter
reg [7:0] W_COUNT;  // Write Counter
reg WINDOW_FLAG;
reg [7:0] COL_COUNT;
reg [7:0] VSYNC;
reg [7:0] fifo1 [WIDTH-1:0];
reg [7:0] fifo2 [WIDTH-1:0];
reg [7:0] fifo3 [WIDTH-1:0];
initial begin
  fifo1_data_o <= 8'b0000_0000;
  fifo2_data_o <= 8'b0000_0000;
  fifo3_data_o <= 8'b0000_0000;
  idle <= 1'b1;
  ready <= 1'b0;
  done <= 1'b0;
  MODE = 1'b0;
  COL_COUNT = 8'b0000_0000;
  W_COUNT = 8'b0000_0000;
  WINDOW_FLAG = 1'b0;
  VSYNC = 8'b0000_0010;
end

always @(posedge clk) begin
  if (data_valid == 1'b1 && MODE == 1'b0) begin
    fifo1[0] = fifo1[1];
    fifo1[1] = fifo1[2];
    fifo1[2] = fifo1[3];
    fifo1[3] = fifo1[4];
    fifo1[4] = fifo2[0];
    fifo2[0] = fifo2[1];
    fifo2[1] = fifo2[2];
    fifo2[2] = fifo2[3];
    fifo2[3] = fifo2[4];
    fifo2[4] = fifo3[0];
    fifo3[0] = fifo3[1];
    fifo3[1] = fifo3[2];
    fifo3[2] = fifo3[3];
    fifo3[3] = fifo3[4];
    fifo3[4] = data_i;
    COL_COUNT = COL_COUNT + 8'b0000_0001;
    if (COL_COUNT == 3 * WIDTH) begin
      WINDOW_FLAG = 1'b1;
      COL_COUNT = WIDTH;
    end
    if (WINDOW_FLAG == 1'b1 && COL_COUNT == WIDTH) begin
      idle <= 1'b0;
      ready <= 1'b0;
      COL_COUNT = 8'b0000_0000;
      MODE = 1'b1;
    end
  end
  if (data_valid == 1'b0 && MODE == 1'b1  && idle_i == 1'b1) begin
    idle <= 1'b0;
    ready <= 1'b1;
    if (W_COUNT < WIDTH) begin
      fifo1_data_o <= fifo1[W_COUNT];
      fifo2_data_o <= fifo2[W_COUNT];
      fifo3_data_o <= fifo3[W_COUNT];
      W_COUNT = W_COUNT + 8'b0000_0001;
    end

    if (W_COUNT == WIDTH && done_i == 1'b1) begin
      ready <= 1'b0;
      idle <= 1'b1;
      W_COUNT = 8'b0000_0000;
      MODE = 1'b0;
      VSYNC = VSYNC + 8'b0000_0001;
      if (VSYNC == 8'b0000_0101) begin
        done <= 1'b1;
      end
    end
  end
end
endmodule
