module not_tb();
  
  reg [8:0] b = 0;
  wire [8:0] q;
  
  not_gate uut(
    .b(b),
    .q(q)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    // not 1_0000_0000
    b = 9'b1_0000_0000;
    // not 1_1111_1111
    #1 b = 9'b1_1111_1111;
    // not 1_0101_0101
    #1 b = 9'b1_0101_0101;
    // not 0_0000_1111
    #1 b = 9'b0_0000_1111;
    // not 1_1111_0000
    #1 b = 9'b1_1111_0000;
 
    #5 $finish;
  end
  
endmodule
