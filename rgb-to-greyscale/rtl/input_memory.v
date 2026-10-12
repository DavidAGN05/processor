// Input image memory wrapper.
// The external load port fills this memory before processing starts.
module input_memory (
  input        clk,
  input        write_en,
  input  [13:0] write_addr,
  input  [23:0] write_data,
  input        read_en,
  input  [13:0] read_addr,
  output [23:0] read_data,
  output       read_valid
);

  image_memory #(
    .ADDR_WIDTH(14),
    .DATA_WIDTH(24),
    .DEPTH(16384)
  ) memory (
    .clk        (clk),
    .write_en   (write_en),
    .write_addr (write_addr),
    .write_data (write_data),
    .read_en    (read_en),
    .read_addr  (read_addr),
    .read_data  (read_data),
    .read_valid (read_valid)
  );

endmodule
