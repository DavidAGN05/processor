`include "add.v"
`include "sub.v"
`include "mult.v"
`include "shift.v"
`include "rol.v"
`include "or.v"
`include "and.v"
`include "nand.v"
`include "xnor.v"
`include "not.v"

module alu (
  input signed [8:0] a,
  input signed [8:0] b,
  input [3:0] s,
  output reg signed [9:0] q
);

  wire [9:0] add_result;
  wire [9:0] subtract_result;
  wire [7:0] multiply_result;
  wire [8:0] shift_result;
  wire [8:0] rotate_result;
  wire [8:0] or_result;
  wire [8:0] and_result;
  wire [8:0] nand_result;
  wire [8:0] xnor_result;
  wire [8:0] not_result;

  add add_unit (
    .a(a),
    .b(b),
    .q(add_result)
  );

  sub subtract_unit (
    .a(a),
    .b(b),
    .q(subtract_result)
  );

  mult multiply_unit (
    .a(a),
    .b(b),
    .q(multiply_result)
  );

  shift shift_unit (
    .a(a),
    .b(b),
    .q(shift_result)
  );

  rol rotate_unit (
    .a(a),
    .b(b),
    .q(rotate_result)
  );

  or_gate or_unit (
    .a(a),
    .b(b),
    .q(or_result)
  );

  and_gate and_unit (
    .a(a),
    .b(b),
    .q(and_result)
  );

  nand_gate nand_unit (
    .a(a),
    .b(b),
    .q(nand_result)
  );

  xnor_gate xnor_unit (
    .a(a),
    .b(b),
    .q(xnor_result)
  );

  not_gate not_unit (
    .b(b),
    .q(not_result)
  );

  always @(*) begin
    case (s)
      4'd0: q = add_result; // 10-bit result for addition
      4'd1: q = subtract_result; // 10-bit result for subtraction
      4'd2: q = {2'b00, multiply_result}; // 10-bit result for multiplication (zero-extended)
      4'd3: q = {1'b0, shift_result}; // 10-bit result for right shift (zero-extended)
      4'd4: q = {1'b0, rotate_result}; // 10-bit result for rotate left (zero-extended) 
      4'd5: q = {1'b0, or_result}; // 10-bit result for OR operation (zero-extended)
      4'd6: q = {1'b0, and_result}; // 10-bit result for AND operation (zero-extended)
      4'd7: q = {1'b0, nand_result}; // 10-bit result for NAND operation (zero-extended)
      4'd8: q = {1'b0, xnor_result}; // 10-bit result for XNOR operation (zero-extended)
      4'd9: q = {1'b0, not_result}; // 10-bit result for NOT operation (zero-extended)
      default: q = 10'b0;
    endcase
  end

endmodule