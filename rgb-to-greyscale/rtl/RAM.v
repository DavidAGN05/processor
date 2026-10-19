module RAM (
    input wire clk,
    input wire [13:0] addr,
    input wire en,
    input wire wr,
    input wire [7:0] d_in,
    output reg [7:0] d_out
);

    reg [7:0] memory [0:16383]; // 16K x 8-bit RAM

    always @(posedge clk) begin
        if (en) begin
            if (wr) begin
                memory[addr] <= d_in; // Write operation
            end else begin
                d_out <= memory[addr]; // Read operation
            end
        end
    end

endmodule