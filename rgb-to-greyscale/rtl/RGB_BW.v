module RGB_BW (
  input wire [7:0] red,
  input wire [7:0] green,
  input wire [7:0] blue,
  output reg [7:0] bw
);

  reg [8:0] weighted_sum;

  always @(*) begin
    // Shift-and-add approximation:
    // 0.25*red + 0.6875*green + 0.0625*blue
    weighted_sum = (red >> 2)
                 + (green >> 1)
                 + (green >> 3)
                 + (green >> 4)
                 + (blue >> 4);
    bw = weighted_sum[7:0];
  end
endmodule
