// Processing and readback controller.
//
// Image loading is controlled directly by top.v through input_memory.
// This FSM controls the processing reads, output writes, and output reads.
module controller (
  input        clk,
  input        reset,
  input        start,
  input        input_read_valid,
  input        read_en,
  input  [13:0] read_addr,

  output reg        input_mem_read_en,
  output reg [13:0] input_mem_read_addr,
  output reg        output_mem_write_en,
  output reg [13:0] output_mem_write_addr,
  output reg        output_mem_read_en,
  output reg [13:0] output_mem_read_addr,
  output reg        busy,
  output reg        done
);

  localparam STATE_IDLE  = 3'd0;
  localparam STATE_READ  = 3'd1;
  localparam STATE_WAIT  = 3'd2;
  localparam STATE_WRITE = 3'd3;
  localparam STATE_DONE  = 3'd4;

  reg [2:0]  state;
  reg [13:0] pixel_count;

  always @(posedge clk) begin
    if (reset) begin
      state       <= STATE_IDLE;
      pixel_count <= 14'd0;
    end else begin
      case (state)
        STATE_IDLE: begin
          if (start) begin
            pixel_count <= 14'd0;
            state       <= STATE_READ;
          end
        end

        STATE_READ: begin
          state <= STATE_WAIT;
        end

        STATE_WAIT: begin
          if (input_read_valid)
            state <= STATE_WRITE;
        end

        STATE_WRITE: begin
          if (pixel_count == 14'd16383) begin
            state <= STATE_DONE;
          end else begin
            pixel_count <= pixel_count + 14'd1;
            state       <= STATE_READ;
          end
        end

        STATE_DONE: begin
          if (start) begin
            pixel_count <= 14'd0;
            state       <= STATE_READ;
          end
        end

        default: begin
          state       <= STATE_IDLE;
          pixel_count <= 14'd0;
        end
      endcase
    end
  end

  always @(*) begin
    input_mem_read_en    = 1'b0;
    input_mem_read_addr  = pixel_count;
    output_mem_write_en  = 1'b0;
    output_mem_write_addr = pixel_count;
    output_mem_read_en   = 1'b0;
    output_mem_read_addr = read_addr;
    busy                 = 1'b0;
    done                 = 1'b0;

    case (state)
      STATE_READ,
      STATE_WAIT,
      STATE_WRITE: begin
        input_mem_read_en   = (state == STATE_READ);
        output_mem_write_en = (state == STATE_WRITE);
        busy                = 1'b1;
      end

      STATE_DONE: begin
        output_mem_read_en = read_en;
        busy               = 1'b0;
        done               = 1'b1;
      end

      default: begin
        // Defaults above describe the IDLE state.
      end
    endcase
  end

endmodule
