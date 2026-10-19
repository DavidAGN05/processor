module counter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [13:0] data,
    output reg [13:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 14'd0;
        else if (enable)
            count <= data + 14'd1;
    end
endmodule