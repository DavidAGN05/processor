module shift (
  input clk,
  input rst,
  input unsigned [8:0] a,
  input unsigned [8:0] b,
  output [8:0] q);

  reg [8:0] a_internal;
  reg [8:0] b_internal;
  reg [8:0] q_internal;

  always @(posedge clk) begin
    if (rst) begin
      a_internal <= 0;
      b_internal <= 0;
      q_internal <= 0;
    end
    else begin
      a_internal <= a;
      b_internal <= b;
      q_internal <= b_internal >> a_internal;
    end
  end

  assign q = q_internal;
endmodule