module not_gate (
  input clk,
  input rst,
  input  [8:0] b,
  output [8:0] q);

  reg [8:0] b_internal;
  reg [8:0] q_internal;

  always @(posedge clk) begin
    if (rst) begin
      b_internal <= 0;
      q_internal <= 0;
    end
    else begin
      b_internal <= b;
      q_internal <= ~b_internal;
    end
  end

  assign q = q_internal;

endmodule