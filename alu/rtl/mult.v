module mult (
  input signed [7:0] a, b,
  output [15:0] q);
  
  assign q = a*b;
endmodule