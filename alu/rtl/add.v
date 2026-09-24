module add (
  input signed [7:0] a, b,
  output [8:0] q);
  
  // sign extneding a and b to 10 bits to avoid overflow
  wire [8:0] a_extended = $signed(a);
  wire [8:0] b_extended = $signed(b);
  
  assign q = a_extended + b_extended;
endmodule