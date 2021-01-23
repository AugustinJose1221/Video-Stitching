module hold(
input clk,
input [7:0] fifo1_data_i,
input [7:0] fifo2_data_i,
input [7:0] fifo3_data_i,
input ready_i,

output reg [7:0] fifo1_data_o,
output reg [7:0] fifo2_data_o,
output reg [7:0] fifo3_data_o,
output reg idle_o,
output reg ready_o,
output reg done_o
);

reg [7:0] hold_data1 [2:0];
reg [7:0] hold_data2 [2:0];
reg [7:0] hold_data3 [2:0];
reg [7:0] COL_COUNT;
reg WINDOW_FLAG;
reg [7:0] HSYNC;
reg [7:0] W_COUNT;
reg MODE;

initial begin
  fifo1_data_o <= 8'b0000_0000;
  fifo2_data_o <= 8'b0000_0000;
  fifo3_data_o <= 8'b0000_0000;
  idle_o <= 1'b1;
  ready_o <= 1'b0;
  done_o <= 1'b0;
  COL_COUNT = 8'b0000_0000;
  WINDOW_FLAG = 1'b0;
  HSYNC = 8'b0000_0010;
  W_COUNT = 8'b0000_0000;
  MODE = 1'b0;
end

always @(posedge clk) begin
  if (ready_i == 1'b1 && MODE == 1'b0) begin
    done_o <= 1'b0;
    hold_data1[0] = hold_data1[1];
    hold_data1[1] = hold_data1[2];
    hold_data1[2] = fifo1_data_i;

    hold_data2[0] = hold_data2[1];
    hold_data2[1] = hold_data2[2];
    hold_data2[2] = fifo2_data_i;

    hold_data3[0] = hold_data3[1];
    hold_data3[1] = hold_data3[2];
    hold_data3[2] = fifo3_data_i;
    COL_COUNT = COL_COUNT + 8'b0000_0001;

    if (COL_COUNT == 8'b0000_0011) begin
      WINDOW_FLAG = 1'b1;
    end
    if (WINDOW_FLAG == 1'b1) begin
      idle_o <= 1'b0;
      ready_o <= 1'b0;
      COL_COUNT = -1;
      MODE = 1'b1;
    end
  end
  if (W_COUNT == 8'b0000_0011) begin
    idle_o <= 1'b1;
    ready_o <= 1'b0;
    W_COUNT = 8'b0000_0000;
    MODE = 1'b0;
    HSYNC = HSYNC + 8'b0000_0001;
    if (HSYNC == 8'b0000_0101) begin
      done_o <= 1'b1;
      WINDOW_FLAG = 1'b0;
      HSYNC = 8'b0000_0010;
      hold_data1[0] = 8'b0000_0000;
      hold_data1[1] = 8'b0000_0000;
      hold_data1[2] = 8'b0000_0000;
      hold_data2[0] = 8'b0000_0000;
      hold_data2[1] = 8'b0000_0000;
      hold_data2[2] = 8'b0000_0000;
      hold_data3[0] = 8'b0000_0000;
      hold_data3[1] = 8'b0000_0000;
      hold_data3[2] = 8'b0000_0000;
      fifo1_data_o <= 8'b0000_0000;
      fifo2_data_o <= 8'b0000_0000;
      fifo3_data_o <= 8'b0000_0000;
    end
  end
  if (MODE == 1'b1) begin
    if (W_COUNT < 8'b0000_0011) begin
      idle_o <= 1'b0;
      ready_o <= 1'b1;
      fifo1_data_o <= hold_data1[W_COUNT];
      fifo2_data_o <= hold_data2[W_COUNT];
      fifo3_data_o <= hold_data3[W_COUNT];
      W_COUNT = W_COUNT + 8'b0000_0001;
    end
  end
end
endmodule
