`timescale 1ns/1ps

module RGB_BW_tb;

  reg  [7:0]  red;
  reg  [7:0]  green;
  reg  [7:0]  blue;
  wire [23:0] gray_pixel;

  integer failures;

  RGB_BW dut (
    .red        (red),
    .green      (green),
    .blue       (blue),
    .gray_pixel (gray_pixel)
  );

  task check_pixel;
    input [7:0]  test_red;
    input [7:0]  test_green;
    input [7:0]  test_blue;
    input [7:0]  expected_gray;
    reg [23:0] expected_pixel;
    begin
      red = test_red;
      green = test_green;
      blue = test_blue;
      #1;
      expected_pixel = {expected_gray, expected_gray, expected_gray};
      if (gray_pixel !== expected_pixel) begin
        $display("FAIL R=%0d G=%0d B=%0d: expected %h, got %h",
                 test_red, test_green, test_blue,
                 expected_pixel, gray_pixel);
        failures = failures + 1;
      end else begin
        $display("PASS R=%0d G=%0d B=%0d -> gray=%0d",
                 test_red, test_green, test_blue, expected_gray);
      end
    end
  endtask

  initial begin
    $dumpfile("RGB_BW_tb.vcd");
    $dumpvars(0, RGB_BW_tb);

    failures = 0;
    check_pixel(8'd0,   8'd0,   8'd0,   8'd0);
    check_pixel(8'd255, 8'd0,   8'd0,   8'd53);
    check_pixel(8'd0,   8'd255, 8'd0,   8'd181);
    check_pixel(8'd0,   8'd0,   8'd255, 8'd17);
    check_pixel(8'd255, 8'd255, 8'd255, 8'd253);
    check_pixel(8'd100, 8'd150, 8'd200, 8'd139);

    if (failures == 0)
      $display("RGB_BW_tb PASSED");
    else
      $display("RGB_BW_tb FAILED: %0d mismatches", failures);

    $finish;
  end

endmodule
