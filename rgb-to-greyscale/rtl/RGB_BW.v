module RGB_BW (
  input wire clk,
  input wire rst,
  input wire [7:0] red,
  input wire [7:0] green,
  input wire [7:0] blue,
  output reg [7:0] bw
);

  wire [8:0] weighted_sum_next;

  assign weighted_sum_next = (red >> 2)
                           + (green >> 1)
                           + (green >> 3)
                           + (green >> 4)
                           + (blue >> 4);

  always @(posedge clk) begin
    if (rst) begin
      bw <= 8'd0;
    end else begin
      // Shift-and-add approximation:
      // 0.25*red + 0.6875*green + 0.0625*blue
      bw <= weighted_sum_next[7:0];
    end
  end
endmodule
