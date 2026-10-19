`include "counter.v"
`include "FSM.v"
`include "RAM.v"
`include "RGB_BW.v"

module Top (
  input wire clk,
  input wire rst,
  input wire [13:0] addr_in,
  input wire [7:0] red_in,
  input wire [7:0] green_in,
  input wire [7:0] blue_in,
  input wire load_in,
  output wire ready_out,
  output wire [7:0] results_out
);

  wire clk_rst;
  wire addr_sel1;
  wire addr_sel2;
  wire color_RAM_en;
  wire color_RAM_wr;
  wire out_RAM_en;
  wire out_RAM_wr;
  wire [13:0] rgb_addr;
  wire [13:0] out_addr;
  wire [13:0] count;
  wire [13:0] count0;
  wire [7:0] red_out;
  wire [7:0] green_out;
  wire [7:0] blue_out;
  wire [7:0] bw_out;
  wire counter_enable;
  wire main_counter_enable;

  counter feedback_counter (
    .clk(clk),
    .rst(clk_rst),
    .enable(counter_enable),
    .data(count),
    .count(count)
  );

  counter main_counter (
    .clk(clk),
    .rst(clk_rst),
    .enable(main_counter_enable),
    .data(count),
    .count(count0)
  );

  FSM controller (
    .clk(clk),
    .load_in(load_in),
    .rst(rst),
    .last_pixel(count0 == 14'd16383),
    .clk_rst(clk_rst),
    .addr_sel1(addr_sel1),
    .addr_sel2(addr_sel2),
    .color_RAM_en(color_RAM_en),
    .color_RAM_wr(color_RAM_wr),
    .out_RAM_en(out_RAM_en),
    .out_RAM_wr(out_RAM_wr),
    .ready_out(ready_out)
  );

  RAM Red_RAM (
    .clk(clk),
    .addr(rgb_addr),
    .en(color_RAM_en),
    .wr(color_RAM_wr),
    .d_in(red_in),
    .d_out(red_out)
  );

  RAM Green_RAM (
    .clk(clk),
    .addr(rgb_addr),
    .en(color_RAM_en),
    .wr(color_RAM_wr),
    .d_in(green_in),
    .d_out(green_out)
  );

  RAM Blue_RAM (
    .clk(clk),
    .addr(rgb_addr),
    .en(color_RAM_en),
    .wr(color_RAM_wr),
    .d_in(blue_in),
    .d_out(blue_out)
  );

  RGB_BW converter (
    .red(red_out),
    .green(green_out),
    .blue(blue_out),
    .bw(bw_out)
  );

  RAM Out_RAM (
    .clk(clk),
    .addr(out_addr),
    .en(out_RAM_en),
    .wr(out_RAM_wr),
    .d_in(bw_out),
    .d_out(results_out)
  );

  assign rgb_addr = addr_sel1 ? addr_in : count;
  assign out_addr = addr_sel2 ? addr_in : count0;
  assign counter_enable = color_RAM_en && !color_RAM_wr;
  assign main_counter_enable = out_RAM_en && out_RAM_wr;

endmodule
