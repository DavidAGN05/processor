module or_gate_tb();

  reg clk = 1;
  reg rst = 1;
  reg [9:0] a = 0;
  reg [9:0] b = 0;
  wire [9:0] q;

  integer period = 10;

  or_gate uut(
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

    // 00_0000_0001 or 10_0000_0000
    a = 10'b00_0000_0001; b = 10'b10_0000_0000;
    #(2*period);

    // 00_0000_0000 or 11_1111_1111
    a = 10'b00_0000_0000; b = 10'b11_1111_1111;
    #(2*period);

    // 00_1010_1010 or 11_0101_0101
    a = 10'b00_1010_1010; b = 10'b11_0101_0101;
    #(2*period);

    // 00_0000_0000 or 00_0000_0000
    a = 10'b00_0000_0000; b = 10'b00_0000_0000;
    #(2*period);

    // 01_0101_0101 or 01_0101_0101
    a = 10'b01_0101_0101; b = 10'b01_0101_0101;
    #(2*period);

    // 11_1110_0000 or 00_0001_1111
    a = 10'b11_1110_0000; b = 10'b00_0001_1111;
    #(2*period);

    // 11_1111_1111 or 11_1111_1111
    a = 10'b11_1111_1111; b = 10'b11_1111_1111;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
