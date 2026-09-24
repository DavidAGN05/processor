module and_gate (
  input  [8:0] a, b,
  output [8:0] q);

  assign q = a & b;

endmodule