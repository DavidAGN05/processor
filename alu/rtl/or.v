module or_gate (
  input  [9:0] a, b,
  output [9:0] q);

  assign q = a | b;

endmodule