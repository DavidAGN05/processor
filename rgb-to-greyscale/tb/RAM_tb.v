module RAM_tb;
  reg clk;
  reg rst;
  reg [5:0] addr;
  reg en;
  reg wr;
  reg [7:0] d_in;
  wire [7:0] d_out;

  RAM dut (.clk(clk), .rst(rst), .addr(addr), .en(en), .wr(wr), .d_in(d_in), .d_out(d_out));
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, RAM_tb);

    clk = 0;
    rst = 1;
    addr = 6'd12;
    d_in = 8'hA5;
    en = 1;
    wr = 1;
    @(posedge clk);
    #1;
    rst = 0;
    en = 1;
    wr = 0;
    @(posedge clk);
    #1;
    if (d_out !== 8'hA5)
      $display("RAM_tb FAILED: expected A5, got %h", d_out);
    else
      $display("RAM_tb PASSED");
    $finish;
  end
endmodule
