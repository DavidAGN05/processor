module mult_tb();

  reg clk = 1;
  reg rst = 1;
  reg signed [7:0] a = 0;
  reg signed [7:0] b = 0;
  wire signed [15:0] q;

  integer period = 10;

  mult uut(
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

    // 0*0
    a = 8'b0; b = 8'b0;
    #(2*period);

    // 0*1
    a = 8'b0; b = 8'b0000_0001;
    #(2*period);

    // 0 * -1
    a = 8'b0; b = 8'b1111_1111;
    #(2*period);

    // 1*1
    a = 8'b0000_0001; b = 8'b0000_0001;
    #(2*period);

    // -1 * -1
    a = 8'b1111_1111; b = 8'b1111_1111;
    #(2*period);

    // 1 * -1
    a = 8'b0000_0001; b = 8'b1111_1111;
    #(2*period);

    // 8*7
    a = 8'b0000_1000; b = 8'b0000_0111;
    #(2*period);

    // -5*10
    a = 8'b1111_1011; b = 8'b0000_1010;
    #(2*period);

    // -11 * -11
    a = 8'b1111_0101; b = 8'b1111_0101;
    #(2*period);

    // 127 * -128 (min)
    a = 8'b0111_1111; b = 8'b1000_0000;
    #(2*period);

    // -128 * -128 (max)
    a = 8'b1000_0000; b = 8'b1000_0000;
    #(2*period);

    // 127 * 1 (max 8-bit output)
    a = 8'b0111_1111; b = 8'b0000_0001;
    #(2*period);

    // -16 * 8 (min 8-bit output)
    a = 8'b1111_0000; b = 8'b0000_1000;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
