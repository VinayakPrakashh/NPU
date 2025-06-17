module window1_pipo #(
    parameter BIT_DEPTH = 8 // Width of the data stored in BRAM
) (
    input clk,
    input wr_en, // Write enable signal
    input [BIT_DEPTH-1:0] in1,
    input [BIT_DEPTH-1:0] in2,
    input [BIT_DEPTH-1:0] in3,
    output [BIT_DEPTH-1:0] w1_r1_col1,
    output [BIT_DEPTH-1:0] w1_r1_col2,
    output [BIT_DEPTH-1:0] w1_r1_col3,
    output [BIT_DEPTH-1:0] w1_r2_col1,
    output [BIT_DEPTH-1:0] w1_r2_col2,
    output [BIT_DEPTH-1:0] w1_r2_col3,
    output [BIT_DEPTH-1:0] w1_r3_col1,
    output [BIT_DEPTH-1:0] w1_r3_col2,
    output [BIT_DEPTH-1:0] w1_r3_col3
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
assign w1_r1_col1 = window1_1[0];
assign w1_r1_col2 = window1_1[1]; 
assign w1_r1_col3 = window1_1[2];
assign w1_r2_col1 = window1_2[0];
assign w1_r2_col2 = window1_2[1]; 
assign w1_r2_col3 = window1_2[2];
assign w1_r3_col1 = window1_3[0];
assign w1_r3_col2 = window1_3[1]; 
assign w1_r3_col3 = window1_3[2];
endmodule