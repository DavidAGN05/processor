`include "image_memory.v"
`include "input_memory.v"
`include "output_memory.v"
`include "RGB_BW.v"
`include "controller.v"

module top (
  input        clk,
  input        rst,

  input        load_en,
  input  [13:0] load_addr,
  input  [23:0] load_pixel,
  input        start,

  input        read_en,
  input  [13:0] read_addr,
  output [23:0] read_pixel,
  output       output_valid,
  output       busy,
  output       done
);

  wire [23:0] input_pixel;
  wire        input_read_valid;
  wire [23:0] gray_pixel;

  wire        input_mem_read_en;
  wire [13:0] input_mem_read_addr;

  wire        output_mem_write_en;
  wire [13:0] output_mem_write_addr;
  wire        output_mem_read_en;
  wire [13:0] output_mem_read_addr;

  wire [23:0] output_mem_read_data;
  wire        output_mem_read_valid;

  input_memory input_mem (
    .clk        (clk),
    .write_en   (load_en),
    .write_addr (load_addr),
    .write_data (load_pixel),
    .read_en    (input_mem_read_en),
    .read_addr  (input_mem_read_addr),
    .read_data  (input_pixel),
    .read_valid (input_read_valid)
  );

  RGB_BW converter (
    .red        (input_pixel[23:16]),
    .green      (input_pixel[15:8]),
    .blue       (input_pixel[7:0]),
    .gray_pixel (gray_pixel)
  );

  output_memory output_mem (
    .clk        (clk),
    .write_en   (output_mem_write_en),
    .write_addr (output_mem_write_addr),
    .write_data (gray_pixel),
    .read_en    (output_mem_read_en),
    .read_addr  (output_mem_read_addr),
    .read_data  (output_mem_read_data),
    .read_valid (output_mem_read_valid)
  );

  controller control (
    .clk                   (clk),
    .reset                 (rst),
    .start                 (start),
    .input_read_valid      (input_read_valid),
    .read_en               (read_en),
    .read_addr             (read_addr),
    .input_mem_read_en     (input_mem_read_en),
    .input_mem_read_addr   (input_mem_read_addr),
    .output_mem_write_en   (output_mem_write_en),
    .output_mem_write_addr (output_mem_write_addr),
    .output_mem_read_en    (output_mem_read_en),
    .output_mem_read_addr  (output_mem_read_addr),
    .busy                  (busy),
    .done                  (done)
  );

  assign read_pixel   = output_mem_read_data;
  assign output_valid = output_mem_read_valid;

endmodule