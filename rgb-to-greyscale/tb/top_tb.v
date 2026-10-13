module top_tb();

	localparam IMAGE_SIZE = 16384;

	reg clk = 1;
	reg rst = 1;
	reg load_en = 0;
	reg [13:0] load_addr = 0;
	reg [23:0] load_pixel = 0;
	reg start = 0;
	reg read_en = 0;
	reg [13:0] read_addr = 0;
	wire [23:0] read_pixel;
	wire output_valid;
	wire busy;
	wire done;
	integer period = 10;
	integer index;
	integer mismatches = 0;
	integer timeout_cycles = 0;
	reg [23:0] expected [0:IMAGE_SIZE-1];

	top uut(
		.clk(clk),
		.rst(rst),
		.load_en(load_en),
		.load_addr(load_addr),
		.load_pixel(load_pixel),
		.start(start),
		.read_en(read_en),
		.read_addr(read_addr),
		.read_pixel(read_pixel),
		.output_valid(output_valid),
		.busy(busy),
		.done(done)
	);

	function [23:0] test_pixel;
		input integer pixel_index;
		reg [7:0] test_red;
		reg [7:0] test_green;
		reg [7:0] test_blue;
		begin
			test_red = (pixel_index * 13 + 7) & 8'hff;
			test_green = (pixel_index * 29 + 19) & 8'hff;
			test_blue = (pixel_index * 47 + 31) & 8'hff;
			test_pixel = {test_red, test_green, test_blue};
		end
	endfunction

	function [23:0] expected_pixel;
		input integer pixel_index;
		reg [23:0] pixel;
		reg [7:0] test_red;
		reg [7:0] test_green;
		reg [7:0] test_blue;
		reg [15:0] weighted_sum;
		reg [7:0] expected_gray;
		begin
			pixel = test_pixel(pixel_index);
			test_red = pixel[23:16];
			test_green = pixel[15:8];
			test_blue = pixel[7:0];
			weighted_sum = 16'd54 * test_red
				+ 16'd182 * test_green
				+ 16'd18 * test_blue;
			expected_gray = weighted_sum[15:8];
			expected_pixel = {expected_gray, expected_gray, expected_gray};
		end
	endfunction

	initial begin
		forever #(period/2) clk = ~clk;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;

		#(2*period);
		rst = 1'b0;
		#(2*period);

		// Load all input pixels and build the fixed-point reference image.
		for (index = 0; index < IMAGE_SIZE; index = index + 1) begin
			@(posedge clk);
			load_en <= 1'b1;
			load_addr <= index[13:0];
			load_pixel <= test_pixel(index);
			expected[index] = expected_pixel(index);
		end

		@(posedge clk);
		load_en <= 1'b0;
		load_addr <= 14'd0;
		load_pixel <= 24'd0;

		// Start processing with a one-clock pulse.
		@(posedge clk);
		start <= 1'b1;
		@(posedge clk);
		start <= 1'b0;

		// Wait for the controller to process all 16,384 pixels.
		while (!done && timeout_cycles < 100000) begin
			@(posedge clk);
			timeout_cycles = timeout_cycles + 1;
		end

		if (!done) begin
			$display("FAIL: timeout waiting for done");
			$finish;
		end

		$display("Processing complete after %0d cycles", timeout_cycles);

		// Read and compare every output pixel.
		for (index = 0; index < IMAGE_SIZE; index = index + 1) begin
			@(posedge clk);
			read_en <= 1'b1;
			read_addr <= index[13:0];
			@(posedge clk);
			#1;

			if (!output_valid) begin
				$display("FAIL: output_valid low for address %0d", index);
				mismatches = mismatches + 1;
			end
			if (read_pixel !== expected[index]) begin
				$display("FAIL address %0d: expected %h, got %h",
					index, expected[index], read_pixel);
				mismatches = mismatches + 1;
			end
		end

		@(posedge clk);
		read_en <= 1'b0;
		read_addr <= 14'd0;

		if (mismatches == 0)
			$display("top_tb PASSED: all %0d pixels matched", IMAGE_SIZE);
		else
			$display("top_tb FAILED: %0d mismatches", mismatches);

		#10 $finish;
	end

endmodule
