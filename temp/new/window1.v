module window1 #(
    parameter BIT_DEPTH = 8 // Width of the data stored in BRAM
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
reg [7:0] window1_1 [0:2];
reg [7:0] window1_2 [0:2];
reg [7:0] window1_3 [0:2];

always @(posedge clk) begin
    if(wr_en) begin
        window1_1[0] <= in1;
        window1_2[0] <= in2;
        window1_3[0] <= in3;
        
        window1_1[1] <= window1_1[0];
        window1_2[1] <= window1_2[0];
        window1_3[1] <= window1_3[0];
        
        window1_1[2] <= window1_1[1];
        window1_2[2] <= window1_2[1];
        window1_3[2] <= window1_3[1];
    end
end
assign out1 = window1_1[2];
assign out2 = window1_2[2]; 
assign out3 = window1_3[2];
endmodule