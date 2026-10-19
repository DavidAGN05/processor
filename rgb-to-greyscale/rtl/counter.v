module counter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [5:0] data,
    output reg [5:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 6'd0;
        else if (enable)
            count <= data + 6'd1;
    end
endmodule