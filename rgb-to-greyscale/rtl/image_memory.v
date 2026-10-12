// Synchronous-read, synchronous-write image memory.
module image_memory #(
  parameter ADDR_WIDTH = 14,
  parameter DATA_WIDTH = 24,
  parameter DEPTH = 16384
) (
  input                       clk,
  input                       write_en,
  input  [ADDR_WIDTH-1:0]     write_addr,
  input  [DATA_WIDTH-1:0]     write_data,
  input                       read_en,
  input  [ADDR_WIDTH-1:0]     read_addr,
  output reg [DATA_WIDTH-1:0] read_data,
  output reg                  read_valid
);

  reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

  always @(posedge clk) begin
    if (write_en)
      memory[write_addr] <= write_data;

    read_valid <= read_en;
    if (read_en)
      read_data <= memory[read_addr];
  end

endmodule
