module dff #(
    parameter WIDTH = 1
) (
    input clk,
    input rst,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);  
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; // Reset output to zero
        end else begin
            q <= d; // Capture input on clock edge
        end
    end
endmodule