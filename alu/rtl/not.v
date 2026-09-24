module not_gate (
  input  [8:0] b,
  output [8:0] q);

  assign q = ~b;

endmodule