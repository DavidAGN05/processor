module add (
  input clk,
  input rst,
  input signed [7:0] a,
  input signed [7:0] b,  
  output signed [8:0] q);

  reg signed [7:0] a_internal;  
  reg signed [7:0] b_internal;  
  reg signed [8:0] q_internal;
  
  always @(posedge clk) begin
    if (rst) begin
      a_internal <= 0;
      b_internal <= 0;
      q_internal <= 0;
    end 
    else begin
      a_internal <= a;
      b_internal <= b;
      q_internal <= a_internal + b_internal;
    end
  end

  assign q = q_internal[7:0];

endmodule