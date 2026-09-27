module shift_tb();

  reg clk = 1;
  reg rst = 1;
  reg [8:0] a = 0;
  reg [8:0] b = 0;
  wire [8:0] q;

  integer period = 10;

  shift uut(
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

    // 1_1111_1111 >> 0 (min shift)
    a = 9'b0; b = 9'b1_1111_1111;
    #(2*period);

    // 0_0000_0000 >> 2
    a = 9'b0_0000_0010; b = 9'b0_0000_0000;
    #(2*period);

    // 0_0000_0001 >> 1
    a = 9'b0_0000_0001; b = 9'b0_0000_0001;
    #(2*period);

    // 1_0000_0000 >> 8
    a = 9'b0_0000_1000; b = 9'b1_0000_0000;
    #(2*period);

    // 1_0101_0101 >> 3
    a = 9'b0_0000_0011; b = 9'b1_0101_0101;
    #(2*period);

    // 1_1111_1111 >> 4
    a = 9'b0_0000_0100; b = 9'b1_1111_1111;
    #(2*period);

    // 1_0001_0001 >> 10
    a = 9'b0_0000_1010; b = 9'b1_0001_0001;
    #(2*period);

    // 1_1111_1111 >> 511 (max shift)
    a = 9'b1_1111_1111; b = 9'b0_1111_0000;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
