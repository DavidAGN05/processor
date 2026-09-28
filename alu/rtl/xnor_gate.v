module xnor_gate (
  input clk,
  input rst,
  input  [7:0] a,
  input  [7:0] b,
  output [7:0] q);

  reg [7:0] a_internal;
  reg [7:0] b_internal;
  reg [7:0] q_internal;

  always @(posedge clk) begin
    if (rst) begin
      a_internal <= 0;
      b_internal <= 0;
      q_internal <= 0;
    end
    else begin
      a_internal <= a;
      b_internal <= b;
      q_internal <= ~(a_internal ^ b_internal);
    end
  end

  assign q = q_internal;

endmodule