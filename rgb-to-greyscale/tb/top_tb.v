module top_tb;
  localparam IMAGE_SIZE = 64;
  reg clk;
  reg rst;
  reg [5:0] addr_in;
  reg [7:0] red_in;
  reg [7:0] green_in;
  reg [7:0] blue_in;
  reg load_in;
  wire ready_out;
  wire [7:0] results_out;
  integer i;
  integer failures;
  integer cycles;

  top dut (
    .clk(clk),
    .rst(rst),
    .addr_in(addr_in),
    .red_in(red_in),
    .green_in(green_in),
    .blue_in(blue_in),
    .load_in(load_in),
    .ready_out(ready_out),
    .results_out(results_out)
  );

  function [7:0] expected_gray;
    input integer index;
    reg [7:0] r;
    reg [7:0] g;
    reg [7:0] b;
    reg [8:0] sum;
    begin
      r = (index * 13 + 7) & 255;
      g = (index * 29 + 19) & 255;
      b = (index * 47 + 31) & 255;
      sum = (r >> 2) + (g >> 1) + (g >> 3) + (g >> 4) + (b >> 4);
      expected_gray = sum[7:0];
    end
  endfunction

  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top_tb);

    clk = 1'b0;
    rst = 1'b1;
    addr_in = 6'd0;
    red_in = 8'd0;
    green_in = 8'd0;
    blue_in = 8'd0;
    load_in = 1'b0;
    failures = 0;
    cycles = 0;

    repeat (2) @(posedge clk);
    rst = 1'b0;

    // Keep the FSM in LOAD until the first input write has been presented.
    @(negedge clk);
    load_in = 1'b1;
    for (i = 0; i < IMAGE_SIZE; i = i + 1) begin
      addr_in = i[5:0];
      red_in = (i * 13 + 7) & 255;
      green_in = (i * 29 + 19) & 255;
      blue_in = (i * 47 + 31) & 255;
      @(posedge clk);
      if (i != IMAGE_SIZE - 1)
        @(negedge clk);
    end

    @(negedge clk);
    load_in = 1'b0;
    addr_in = 6'd0;

    while (!ready_out && cycles < IMAGE_SIZE * 3) begin
      @(posedge clk);
      cycles = cycles + 1;
    end

    if (!ready_out) begin
      $display("FAIL: timeout waiting for ready_out");
      failures = failures + 1;
    end

    for (i = 0; i < IMAGE_SIZE; i = i + 1) begin
      @(negedge clk);
      addr_in = i[5:0];
      @(posedge clk);
      #1;
      if (results_out !== expected_gray(i)) begin
        $display("FAIL address %0d: expected %0d, got %0d",
                 i, expected_gray(i), results_out);
        failures = failures + 1;
      end
    end

    if (failures == 0)
      $display("top_tb PASSED: all %0d pixels matched", IMAGE_SIZE);
    else
      $display("top_tb FAILED: %0d failures", failures);
    $finish;
  end
endmodule
