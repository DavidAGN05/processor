module FSM (
    input wire load_in,
    input wire clk,
    input wire rst,
    input wire last_pixel,
    output reg clk_rst,
    output reg addr_sel1,
    output reg addr_sel2,
    output reg color_RAM_en,
    output reg color_RAM_wr,
    output reg out_RAM_en,
    output reg out_RAM_wr,
    output reg ready_out
);

    localparam STATE_LOAD = 2'd0;
    localparam STATE_PROCESS = 2'd1;
    localparam STATE_WRITE_OUT = 2'd2;
    localparam STATE_DONE = 2'd3;

    reg [1:0] current_state;
    reg [1:0] next_state;

    always @(posedge clk) begin
        if (rst)
            current_state <= STATE_LOAD;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_LOAD:
                if (load_in)
                    next_state = STATE_LOAD;
                else
                    next_state = STATE_PROCESS;
            STATE_PROCESS:
                next_state = STATE_WRITE_OUT;
            STATE_WRITE_OUT:
                if (last_pixel)
                    next_state = STATE_DONE;
                else
                    next_state = STATE_PROCESS;
            STATE_DONE:
                if (load_in)
                    next_state = STATE_LOAD;
            default:
                next_state = STATE_LOAD;
        endcase
    end

    always @(*) begin
        clk_rst = 1'b0;
        addr_sel1 = 1'b0;
        addr_sel2 = 1'b0;
        color_RAM_en = 1'b0;
        color_RAM_wr = 1'b0;
        out_RAM_en = 1'b0;
        out_RAM_wr = 1'b0;
        ready_out = 1'b0;

        case (current_state)
            STATE_LOAD: begin
                clk_rst = 1'b1;
                addr_sel1 = 1'b1;
                color_RAM_en = load_in;
                color_RAM_wr = load_in;
            end
            STATE_PROCESS:
                color_RAM_en = 1'b1;
            STATE_WRITE_OUT: begin
                out_RAM_en = 1'b1;
                out_RAM_wr = 1'b1;
            end
            STATE_DONE: begin
                addr_sel2 = 1'b1;
                out_RAM_en = 1'b1;
                ready_out = 1'b1;
            end
            default:
                clk_rst = 1'b1;
        endcase
    end
endmodule
