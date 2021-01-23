module file_read();
reg [7:0] mem [24:0];
integer i;

initial begin
  $readmemh("data.txt", mem);
end

initial begin
  for(i = 0; i < 25; i=i+1) begin
    $display("%h", mem[i]);
  end
end
endmodule
