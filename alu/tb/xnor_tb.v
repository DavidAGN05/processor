module xnor_tb();

  reg clk = 1;
  reg rst = 1;
  reg [7:0] a = 0;
  reg [7:0] b = 0;
  wire [7:0] q;

  integer period = 10;

  xnor_gate uut(
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

    // 0000_0001 xnor 1000_0000
    a = 8'b0000_0001; b = 8'b1000_0000;
    #(2*period);

    // 0000_0000 xnor 1111_1111
    a = 8'b0000_0000; b = 8'b1111_1111;
    #(2*period);

    // 0101_0101 xnor 1010_1010
    a = 8'b0101_0101; b = 8'b1010_1010;
    #(2*period);

    // 0000_0000 xnor 0000_0000
    a = 8'b0000_0000; b = 8'b0000_0000;
    #(2*period);

    // 1010_1010 xnor 1010_1010
    a = 8'b1010_1010; b = 8'b1010_1010;
    #(2*period);

    // 1111_0000 xnor 0000_1111
    a = 8'b1111_0000; b = 8'b0000_1111;
    #(2*period);

    // 1111_1111 xnor 1111_1111
    a = 8'b1111_1111; b = 8'b1111_1111;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
