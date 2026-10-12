`timescale 1ns/1ps

module top_tb;

  localparam IMAGE_SIZE = 16384;

  reg         clk;
  reg         reset;
  reg         load_en;
  reg  [13:0] load_addr;
  reg  [23:0] load_pixel;
  reg         start;
  reg         read_en;
  reg  [13:0] read_addr;
  wire [23:0] read_pixel;
  wire        output_valid;
  wire        busy;
  wire        done;

  reg [23:0] expected [0:IMAGE_SIZE-1];
  integer index;
  integer mismatches;
  integer timeout_cycles;
  reg [7:0] red_value;
  reg [7:0] green_value;
  reg [7:0] blue_value;
  reg [15:0] weighted_sum;
  reg [7:0] expected_gray;

  top dut (
    .clk          (clk),
    .reset        (reset),
    .load_en      (load_en),
    .load_addr    (load_addr),
    .load_pixel   (load_pixel),
    .start        (start),
    .read_en      (read_en),
    .read_addr    (read_addr),
    .read_pixel   (read_pixel),
    .output_valid (output_valid),
    .busy         (busy),
    .done         (done)
  );

  always #5 clk = ~clk;

  function [23:0] test_pixel;
    input integer pixel_index;
    reg [7:0] test_red;
    reg [7:0] test_green;
    reg [7:0] test_blue;
    begin
      // Deterministic pattern exercises all channel values over the image.
      test_red   = (pixel_index * 13 + 7)  & 8'hff;
      test_green = (pixel_index * 29 + 19) & 8'hff;
      test_blue  = (pixel_index * 47 + 31) & 8'hff;
      test_pixel = {test_red, test_green, test_blue};
    end
  endfunction

  function [23:0] expected_pixel;
    input integer pixel_index;
    reg [23:0] pixel;
    reg [7:0] test_red;
    reg [7:0] test_green;
    reg [7:0] test_blue;
    reg [15:0] test_sum;
    reg [7:0] test_gray;
    begin
      pixel       = test_pixel(pixel_index);
      test_red    = pixel[23:16];
      test_green  = pixel[15:8];
      test_blue   = pixel[7:0];
      test_sum    = 16'd54 * test_red
                  + 16'd182 * test_green
                  + 16'd18 * test_blue;
      test_gray   = test_sum[15:8];
      expected_pixel = {test_gray, test_gray, test_gray};
    end
  endfunction

  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);

    clk = 1'b0;
    reset = 1'b1;
    load_en = 1'b0;
    load_addr = 14'd0;
    load_pixel = 24'd0;
    start = 1'b0;
    read_en = 1'b0;
    read_addr = 14'd0;
    mismatches = 0;
    timeout_cycles = 0;

    repeat (2) @(posedge clk);
    reset = 1'b0;

    // Load every input pixel and build the matching fixed-point reference.
    for (index = 0; index < IMAGE_SIZE; index = index + 1) begin
      @(negedge clk);
      load_en = 1'b1;
      load_addr = index[13:0];
      load_pixel = test_pixel(index);
      expected[index] = expected_pixel(index);
    end
    @(negedge clk);
    load_en = 1'b0;
    load_addr = 14'd0;
    load_pixel = 24'd0;

    // Start processing with a one-cycle pulse.
    @(negedge clk);
    start = 1'b1;
    @(negedge clk);
    start = 1'b0;

    // Wait for all 16,384 pixels to be processed.
    while (!done && timeout_cycles < 100000) begin
      @(posedge clk);
      timeout_cycles = timeout_cycles + 1;
    end

    if (!done) begin
      $display("FAIL: timeout waiting for done");
      $finish;
    end
    $display("Processing complete after %0d cycles", timeout_cycles);

    // Read every output pixel. Synchronous output memory returns data one
    // rising edge after read_en/read_addr are presented.
    for (index = 0; index < IMAGE_SIZE; index = index + 1) begin
      @(negedge clk);
      read_en = 1'b1;
      read_addr = index[13:0];
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

    @(negedge clk);
    read_en = 1'b0;
    read_addr = 14'd0;

    if (mismatches == 0)
      $display("top_tb PASSED: all %0d pixels matched", IMAGE_SIZE);
    else
      $display("top_tb FAILED: %0d mismatches", mismatches);

    $finish;
  end

endmodule
