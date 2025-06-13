module window1 #(
    parameters
) (
    input clk,
    input rst,
    input start,
    input [1:0] stride,
    input [7:0] in_l1,
    input [7:0] in_l2,
    input [7:0] in_l3,
    output reg shift_buffer,
    output reg done
);
 reg [7:0] window1_1 [0:2];
 reg [7:0] window1_2 [0:2];
 reg [7:0] window1_3 [0:2];

 always @(posedge clk) begin
    
 end

 assign 
endmodule