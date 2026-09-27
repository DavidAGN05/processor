module shift_tb();

  reg clk = 1;
  reg rst = 1;
  reg [7:0] a = 0;
  reg [7:0] b = 0;
  wire [7:0] q;

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

    // 1111_1111 >> 0
    a = 8'b0000_0000; b = 8'b1111_1111;
    #(2*period);

    // 0000_0000 >> 2
    a = 8'b0000_0010; b = 8'b0000_0000;
    #(2*period);

    // 0000_0001 >> 1
    a = 8'b0000_0001; b = 8'b0000_0001;
    #(2*period);

    // 1000_0000 >> 3
    a = 8'b0000_0011; b = 8'b1000_0000;
    #(2*period);

    // 1010_1010 >> 1
    a = 8'b0000_0001; b = 8'b1010_1010;
    #(2*period);

    // 1111_1111 >> 4
    a = 8'b0000_0100; b = 8'b1111_1111;
    #(2*period);

    // 1000_0001 >> 2
    a = 8'b0000_0010; b = 8'b1000_0001;
    #(2*period);

    // 1111_0000 >> 7
    a = 8'b0000_0111; b = 8'b1111_0000;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
