module rol (
  input clk,
  input rst,
  input unsigned [7:0] a,
  input [7:0] b,
  output [7:0] q
);

  reg [7:0] a_internal;
  reg [7:0] b_internal;
  reg [7:0] q_internal;

  always @(posedge clk) begin
    if (rst) begin
      a_internal <= 8'b0;
      b_internal <= 8'b0;
      q_internal <= 8'b0;
    end
    else begin
      a_internal <= a;
      b_internal <= b;
      q_internal <= (b_internal << (a_internal % 8'd8)) |
                    (b_internal >> (8'd8 - (a_internal % 8'd8)));
    end
  end

  assign q = q_internal;

endmodule