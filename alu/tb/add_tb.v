module add_tb();

  reg clk = 1;
  reg rst = 1;
  reg [7:0] a = 0;
  reg [7:0] b = 0;
  wire [7:0] q;

  integer period = 10;

  // Instantiate the Unit Under Test (UUT)
  add uut (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .q(q)
  );

  // Clock generator
  initial begin
    forever #(period/2) clk = ~clk;
  end

  // Stimulus
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // Hold reset active initially
    #(2*period);

    rst = 1'b0;
    #(2*period);

    // 0 + 0
    a = 8'b0; b = 8'b0;
    #(2*period);

    // 0 + 1
    a = 8'b0; b = 8'b0000_0001;
    #(2*period);

    // 1 + 0
    a = 8'b0000_0001; b = 8'b0;
    #(2*period);

    // 1 + 1
    a = 8'b0000_0001; b = 8'b0000_0001;
    #(2*period);

    // 0 + 2
    a = 8'b0; b = 8'b0000_0010;
    #(2*period);

    // 1 + 2
    a = 8'b0000_0001; b = 8'b0000_0010;
    #(2*period);

    // 2 + 0
    a = 8'b0000_0010; b = 8'b0;
    #(2*period);

    // 2 + 1
    a = 8'b0000_0010; b = 8'b0000_0001;
    #(2*period);

    // 2 + 2
    a = 8'b0000_0010; b = 8'b0000_0010;
    #(2*period);

    // 127 + 127 (max)
    a = 8'b0111_1111; b = 8'b0111_1111;
    #(2*period);

    // -128 + -128 (min)
    a = 8'b1000_0000; b = 8'b1000_0000;
    #(2*period);

    // -128 + 127 (-1)
    a = 8'b1000_0000; b = 8'b0111_1111;
    #(2*period);

    // -55 + 10
    a = 8'b1100_1001; b = 8'b0000_1010;
    #(2*period);

    // 55 + -10
    a = 8'b0011_0111; b = 8'b1111_0110;
    #(2*period);

    // Final delay before finishing
    #(10*period);
    
    $finish;
  end

endmodule