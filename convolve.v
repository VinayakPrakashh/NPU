module convolve (
    input i_clk,
    input i_rst,
    input i_start,
    input [7:0] i_src1_data,
    input [7:0] i_kernal_data,
    input i_src1_start_addr,
    input i_kernal_start_addr,
);

reg [7:0] kernel [3:0][3:0];
reg [9:0] i;
reg [3:0] i_k, j_k;
reg [15:0] sum;


endmodule