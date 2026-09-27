module and_tb();

  reg clk = 1;
  reg rst = 1;
  reg [8:0] a = 0;
  reg [8:0] b = 0;
  wire [8:0] q;

  integer period = 10;

  and_gate uut(
    .clk(clk),
    .rst(rst),
    .a(a),
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

    // 0_0000_0001 and 1_0000_0000
    a = 9'b0_0000_0001; b = 9'b1_0000_0000;
    #(2*period);

    // 0_0000_0000 and 1_1111_1111
    a = 9'b0_0000_0000; b = 9'b1_1111_1111;
    #(2*period);

    // 0_1010_1010 and 1_0101_0101
    a = 9'b0_1010_1010; b = 9'b1_0101_0101;
    #(2*period);

    // 0_0000_0000 and 0_0000_0000
    a = 9'b0_0000_0000; b = 9'b0_0000_0000;
    #(2*period);

    // 1_0101_0101 and 1_0101_0101
    a = 9'b1_0101_0101; b = 9'b1_0101_0101;
    #(2*period);

    // 0_1111_0000 and 0_0000_1111
    a = 9'b0_1111_0000; b = 9'b0_0000_1111;
    #(2*period);

    // 1_1111_1111 and 1_1111_1111
    a = 9'b1_1111_1111; b = 9'b1_1111_1111;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
