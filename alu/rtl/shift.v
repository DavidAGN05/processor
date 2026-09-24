module shift (
  input unsigned [8:0] a, b,
  output [8:0] q);
  
  assign q = b >> a;
endmodule