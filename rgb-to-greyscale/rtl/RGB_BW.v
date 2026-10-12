// Combinational RGB-to-grayscale converter.
//
// Fixed-point implementation:
// gray = (54 * red + 182 * green + 18 * blue) >> 8
//
// The output is an RGB-formatted grayscale pixel so it can be written
// directly to the 24-bit output image memory.
module RGB_BW (
  input  [7:0]  red,
  input  [7:0]  green,
  input  [7:0]  blue,
  output [23:0] gray_pixel
);

  wire [15:0] red_product;
  wire [15:0] green_product;
  wire [15:0] blue_product;
  wire [15:0] weighted_sum;
  wire [7:0]  gray;

  assign red_product   = 16'd54  * red;
  assign green_product = 16'd182 * green;
  assign blue_product  = 16'd18  * blue;
  assign weighted_sum  = red_product + green_product + blue_product;
  assign gray          = weighted_sum[15:8];

  assign gray_pixel = {gray, gray, gray};

endmodule
