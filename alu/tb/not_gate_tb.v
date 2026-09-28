module not_gate_tb();

  reg clk = 1;
  reg rst = 1;
  reg [7:0] b = 0;
  wire [7:0] q;

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

    // not 1000_0000
    b = 8'b1000_0000;
    #(2*period);

    // not 1111_1111
    b = 8'b1111_1111;
    #(2*period);

    // not 1010_1010
    b = 8'b1010_1010;
    #(2*period);

    // not 0000_1111
    b = 8'b0000_1111;
    #(2*period);

    // not 1111_0000
    b = 8'b1111_0000;
    #(2*period);

    #(10*period);
    $finish;
  end

endmodule
