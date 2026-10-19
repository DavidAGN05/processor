module counter_tb;
  reg clk;
  reg rst;
  reg enable;
  reg [13:0] data;
  wire [13:0] count;

  counter dut (.clk(clk), .rst(rst), .enable(enable), .data(data), .count(count));
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, counter_tb);

    clk = 0;
    rst = 1;
    enable = 0;
    data = 14'd99;
    @(posedge clk);
    #1;
    if (count !== 14'd0) $display("FAIL reset: count=%0d", count);

    rst = 0;
    data = 14'd41;
    enable = 1;
    @(posedge clk);
    #1;
    if (count !== 14'd42) $display("FAIL increment: count=%0d", count);

    enable = 0;
    data = 14'd100;
    @(posedge clk);
    #1;
    if (count !== 14'd42) $display("FAIL hold: count=%0d", count);
    else $display("counter_tb PASSED");
    $finish;
  end
endmodule
