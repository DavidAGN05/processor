`include "add.v"
`include "sub.v"
`include "mult.v"
`include "shift.v"
`include "rol.v"
`include "or_gate.v"
`include "and_gate.v"
`include "nand_gate.v"
`include "xnor_gate.v"
`include "not_gate.v"

module alu (
  input clk,
  input rst,
  input [9:0] a,
  input [9:0] b,
  input [3:0] s,
  output reg [9:0] q
);

  wire [8:0] add_result;
  wire [8:0] subtract_result;
  wire [15:0] multiply_result;
  wire [7:0] shift_result;
  wire [7:0] rotate_result;
  wire [9:0] or_result;
  wire [7:0] and_result;
  wire [7:0] nand_result;
  wire [7:0] xnor_result;
  wire [7:0] not_result;

  add add_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(add_result)
  );

  sub subtract_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(subtract_result)
  );

  mult multiply_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(multiply_result)
  );

  shift shift_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(shift_result)
  );

  rol rotate_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(rotate_result)
  );

  or_gate or_unit (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .q(or_result)
  );

  and_gate and_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(and_result)
  );

  nand_gate nand_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(nand_result)
  );

  xnor_gate xnor_unit (
    .clk(clk),
    .rst(rst),
    .a(a[7:0]),
    .b(b[7:0]),
    .q(xnor_result)
  );

  not_gate not_unit (
    .clk(clk),
    .rst(rst),
    .b(b[7:0]),
    .q(not_result)
  );

  always @(*) begin
    case (s)
      4'd0: q = {{1{add_result[8]}}, add_result};
      4'd1: q = {{1{subtract_result[8]}}, subtract_result};
      4'd2: q = multiply_result[9:0];
      4'd3: q = {2'b00, shift_result};
      4'd4: q = {2'b00, rotate_result};
      4'd5: q = or_result;
      4'd6: q = {2'b00, and_result};
      4'd7: q = {2'b00, nand_result};
      4'd8: q = {2'b00, xnor_result};
      4'd9: q = {2'b00, not_result};
      default: q = 10'b0;
    endcase
  end

endmodule