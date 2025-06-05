module npt_top #(
    parameter 
) (
    input i_clk,
    input i_rst,
    input i_start,
    input [7:0] i_src1_data1,
    input [7:0] i_src1_data2,
    input [9:0] i_src1_start_addr,
    input [9:0] i_kernal_start_addr,
    input [9:0] dest_address1,
    input [9:0] dest_address2,
    input [2:0] i_stride,
    output reg [7:0] o_sum1,
    output reg [7:0] o_sum2,
    output reg o_done,
    output reg [9:0] src1_addr2,
    output [9:0] src1_src2_addr1
);

endmodule