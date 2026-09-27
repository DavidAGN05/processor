module not_tb();

  reg clk = 1;
  reg rst = 1;
  reg [8:0] b = 0;
  wire [8:0] q;

  integer period = 10;

  not_gate uut(
    .clk(clk),
    .rst(rst),
    .b(b),
    .q(q)
  );

  initial begin
    forever #(period/2) clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    #(2*period);
    rst = 1'b0;
    #(2*period);

    // not 1_0000_0000
    b = 9'b1_0000_0000;
    #(2*period);

    // not 1_1111_1111
    b = 9'b1_1111_1111;
    #(2*period);

    // not 1_0101_0101
    b = 9'b1_0101_0101;
    #(2*period);

    // not 0_0000_1111
    b = 9'b0_0000_1111;
    #(2*period);

    // not 1_1111_0000
    b = 9'b1_1111_0000;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
