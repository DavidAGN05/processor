module RGB_BW_tb;
  reg clk;
  reg rst;
  reg [7:0] red;
  reg [7:0] green;
  reg [7:0] blue;
  wire [7:0] bw;
  integer failures;

  RGB_BW dut (
    .clk(clk),
    .rst(rst),
    .red(red),
    .green(green),
    .blue(blue),
    .bw(bw)
  );

  always #5 clk = ~clk;

  task check;
    input [7:0] r;
    input [7:0] g;
    input [7:0] b;
    input [7:0] expected;
    begin
      red = r;
      green = g;
      blue = b;
      @(posedge clk);
      #1;
      if (bw !== expected) begin
        $display("FAIL RGB=(%0d,%0d,%0d): expected %0d, got %0d",
                 r, g, b, expected, bw);
        failures = failures + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, RGB_BW_tb);

    clk = 1'b0;
    rst = 1'b1;
    red = 8'd0;
    green = 8'd0;
    blue = 8'd0;
    failures = 0;
    @(posedge clk);
    rst = 1'b0;
    check(8'd0, 8'd0, 8'd0, 8'd0);
    check(8'd255, 8'd0, 8'd0, 8'd63);
    check(8'd0, 8'd255, 8'd0, 8'd173);
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
