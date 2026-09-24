module alu_tb();

	reg signed [9:0] a = 0;
	reg signed [9:0] b = 0;
	reg [3:0] s = 0;
	wire signed [9:0] q;

	alu uut(
		.a(a),
		.b(b),
		.s(s),
		.q(q)
	);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;

		// All zero inputs: 0 + 0, 0 - 0, 0 * 0, and all bitwise operations
		a = 10'b00_0000_0000; b = 10'b00_0000_0000;
		s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// a = -1 and b = -1
		#1 a = 10'b11_1111_1111; b = 10'b11_1111_1111; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Maximum inputs: 511
		#1 a = 10'b01_1111_1111; b = 10'b01_1111_1111; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Minimum inputs: -512
		#1 a = 10'b10_0000_0000; b = 10'b10_0000_0000; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Minimum input A (-512) and maximum input B (511)
		#1 a = 10'b10_0000_0000; b = 10'b01_1111_1111; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Maximum input A (511) and minimum input B (-512)
		#1 a = 10'b01_1111_1111; b = 10'b10_0000_0000; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Positive one and negative one
		#1 a = 10'b00_0000_0001; b = 10'b11_1111_1111; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Negative and positive one
		#1 a = 10'b11_1111_1111; b = 10'b00_0000_0001; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Alternating bits with A=1
		#1 a = 10'b00_0000_0001; b = 10'b10_1010_1010; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Alternating bits with A=8.
		#1 a = 10'b00_0000_1000; b = 10'b10_1010_1010; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Alternating bits with A=9.
		#1 a = 10'b00_0000_1001; b = 10'b10_1010_1010; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		// Opposite alternating bits.
		#1 a = 10'b01_0101_0101; b = 10'b10_1010_1010; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

        // Same alternating bits.
		#1 a = 10'b01_0101_0101; b = 10'b01_0101_0101; s = 4'd0;
		#1 s = 4'd1;
		#1 s = 4'd2;
		#1 s = 4'd3;
		#1 s = 4'd4;
		#1 s = 4'd5;
		#1 s = 4'd6;
		#1 s = 4'd7;
		#1 s = 4'd8;
		#1 s = 4'd9;

		#10 $finish;
	end

endmodule
