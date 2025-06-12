module window1 #(
    parameter BIT_DEPTH = 8, // Width of the data stored in BRAM
) (
    input clk,
    input wr_en, // Write enable signal
    input [BIT_DEPTH-1:0] in1,
    input [BIT_DEPTH-1:0] in2,
    input [BIT_DEPTH-1:0] in3,
    output [BIT_DEPTH-1:0] out1,
    output [BIT_DEPTH-1:0] out2,
    output [BIT_DEPTH-1:0] out3
);
    
endmodule