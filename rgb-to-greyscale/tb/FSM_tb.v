module FSM_tb;
  reg clk;
  reg rst;
  reg load_in;
  reg last_pixel;
  wire clk_rst;
  wire addr_sel1;
  wire addr_sel2;
  wire color_RAM_en;
  wire color_RAM_wr;
  wire out_RAM_en;
  wire out_RAM_wr;
  wire ready_out;

  FSM dut (
    .clk(clk), .load_in(load_in), .rst(rst), .last_pixel(last_pixel),
    .clk_rst(clk_rst), .addr_sel1(addr_sel1), .addr_sel2(addr_sel2),
    .color_RAM_en(color_RAM_en), .color_RAM_wr(color_RAM_wr),
    .out_RAM_en(out_RAM_en), .out_RAM_wr(out_RAM_wr),
    .ready_out(ready_out)
  );
  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, FSM_tb);

    clk = 0;
    rst = 1;
    load_in = 1;
    last_pixel = 0;
    @(posedge clk);
    #1;
    rst = 0;
    if (!color_RAM_en || !color_RAM_wr)
      $display("FSM_tb FAILED: load controls");

    load_in = 0;
    @(posedge clk);
    #1;
    if (!color_RAM_en || color_RAM_wr)
      $display("FSM_tb FAILED: process controls");

    @(posedge clk);
    #1;
    if (!out_RAM_en || !out_RAM_wr)
      $display("FSM_tb FAILED: write controls");

    last_pixel = 1;
    @(posedge clk);
    #1;
    if (!ready_out)
      $display("FSM_tb FAILED: done state");
    else
      $display("FSM_tb PASSED");
    $finish;
  end
endmodule
