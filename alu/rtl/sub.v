module sub (
  input signed [8:0] a, b,
  output [9:0] q);
  
  wire [9:0] a_extended = $signed(a);
  wire [9:0] b_extended = $signed(b);  
  
  assign q = a_extended - b_extended;
endmodule