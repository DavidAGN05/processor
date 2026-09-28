module alu_tb();

	reg clk = 1;
	reg rst = 1;
	reg [9:0] a = 0;
	reg [9:0] b = 0;
	reg [3:0] s = 0;
	wire [9:0] q;
	integer period = 10;

	alu uut(
		.clk(clk),
		.rst(rst),
		.a(a),
		.b(b),
		.s(s),
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

		// All zero inputs: 0 + 0, 0 - 0, 0 * 0, and all bitwise operations
		a = 10'b00_0000_0000; b = 10'b00_0000_0000;
		s = 4'd0;
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// a = -1 and b = -1
		@(posedge clk) begin a <= 10'b11_1111_1111; b <= 10'b11_1111_1111; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Maximum inputs: 511
		@(posedge clk) begin a <= 10'b01_1111_1111; b <= 10'b01_1111_1111; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Minimum inputs: -512
		@(posedge clk) begin a <= 10'b10_0000_0000; b <= 10'b10_0000_0000; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Minimum input A (-512) and maximum input B (511)
		@(posedge clk) begin a <= 10'b10_0000_0000; b <= 10'b01_1111_1111; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Maximum input A (511) and minimum input B (-512)
		@(posedge clk) begin a <= 10'b01_1111_1111; b <= 10'b10_0000_0000; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Positive one and negative one
		@(posedge clk) begin a <= 10'b00_0000_0001; b <= 10'b11_1111_1111; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Negative and positive one
		@(posedge clk) begin a <= 10'b11_1111_1111; b <= 10'b00_0000_0001; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Alternating bits with A=1
		@(posedge clk) begin a <= 10'b00_0000_0001; b <= 10'b10_1010_1010; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Alternating bits with A=8.
		@(posedge clk) begin a <= 10'b00_0000_1000; b <= 10'b10_1010_1010; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Alternating bits with A=9.
		@(posedge clk) begin a <= 10'b00_0000_1001; b <= 10'b10_1010_1010; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		// Opposite alternating bits.
		@(posedge clk) begin a <= 10'b01_0101_0101; b <= 10'b10_1010_1010; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

        // Same alternating bits.
		@(posedge clk) begin a <= 10'b01_0101_0101; b <= 10'b01_0101_0101; s <= 4'd0; end
		@(posedge clk) s <= 4'd1;
		@(posedge clk) s <= 4'd2;
		@(posedge clk) s <= 4'd3;
		@(posedge clk) s <= 4'd4;
		@(posedge clk) s <= 4'd5;
		@(posedge clk) s <= 4'd6;
		@(posedge clk) s <= 4'd7;
		@(posedge clk) s <= 4'd8;
		@(posedge clk) s <= 4'd9;

		#10 $finish;
	end

endmodule
