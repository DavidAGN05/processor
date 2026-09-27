module add (
  input clk,
  input rst,
  input [7:0] a, b,
  output [7:0] q);

  reg [8:0] q_internal;
  
  always @(posedge clk) begin
    if (rst) begin
      q_internal <= 0;
    end 
    else begin
      q_internal <= {a[7], a} + {b[7], b};
    end
  end

  assign q = q_internal[7:0];
  
endmodule