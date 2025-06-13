module window2 #(
    parameters
) (
    input clk,
    input rst,
    input wr_sft_en,
    input [7:0] in_l1,
    input [7:0] in_l2,
    input [7:0] in_l3,
    output  [7:0] r1_col1,
    output  [7:0] r1_col2,
    output  [7:0] r1_col3,
    output  [7:0] r2_col1,
    output  [7:0] r2_col2,
    output  [7:0] r2_col3,
    output  [7:0] r3_col1,
    output  [7:0] r3_col2,
    output  [7:0] r3_col3
);
 reg [7:0] window1_1 [0:2];
 reg [7:0] window1_2 [0:2];
 reg [7:0] window1_3 [0:2];

 always @(posedge clk) begin
    if(wr_sft_en) begin
        window1_1[0] <= in_l1;
        window1_2[0] <= in_l2;
        window1_2[0] <= in_l3;
        window1_1[1] <= window1_1[0];
        window1_2[1] <= window1_2[0];
        window1_3[1] <= window1_3[0];
        window1_1[2] <= window1_1[1];
        window1_2[2] <= window1_2[1];
        window1_3[2] <= window1_3[1];
    end
 end
    assign  r1_col1 = window1_1[2];
    assign  r1_col2 = window1_1[1];
    assign  r1_col3 = window1_1[0];
    assign  r2_col1 = window1_2[2];
    assign  r2_col2 = window1_2[1];
    assign  r2_col3 = window1_2[0];
    assign  r3_col1 = window1_3[2];
    assign  r3_col2 = window1_3[1];
    assign  r3_col3 = window1_3[0];

 
 
endmodule