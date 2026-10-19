`timescale 1ns/1ps

module RGB_BW_tb;
  reg [7:0] red;
  reg [7:0] green;
  reg [7:0] blue;
  wire [7:0] bw;
  integer failures;

  RGB_BW dut (.red(red), .green(green), .blue(blue), .bw(bw));

  task check;
    input [7:0] r;
    input [7:0] g;
    input [7:0] b;
    input [7:0] expected;
    begin
      red = r;
      green = g;
      blue = b;
      #1;
      if (bw !== expected) begin
        $display("FAIL RGB=(%0d,%0d,%0d): expected %0d, got %0d",
                 r, g, b, expected, bw);
        failures = failures + 1;
      end
    end
  endtask

  initial begin
    failures = 0;
    check(8'd0, 8'd0, 8'd0, 8'd0);
    check(8'd255, 8'd0, 8'd0, 8'd63);
    check(8'd0, 8'd255, 8'd0, 8'd175);
    check(8'd0, 8'd0, 8'd255, 8'd15);
    check(8'd255, 8'd255, 8'd255, 8'd251);
    check(8'd100, 8'd150, 8'd200, 8'd139);

    if (failures == 0)
      $display("RGB_BW_tb PASSED");
    else
      $display("RGB_BW_tb FAILED: %0d failures", failures);
    $finish;
  end
endmodule
