module RGB_BW (
  input wire [7:0] red,
  input wire [7:0] green,
  input wire [7:0] blue,
  output reg [7:0] bw
);

  reg [15:0] red_product;
  reg [15:0] green_product;
  reg [15:0] blue_product;
  reg [16:0] weighted_sum;

  always @(*) begin
    red_product = 16'd54 * red;
    green_product = 16'd182 * green;
    blue_product = 16'd18 * blue;
    weighted_sum = red_product + green_product + blue_product;
    bw = weighted_sum[15:8];
  end
endmodule
