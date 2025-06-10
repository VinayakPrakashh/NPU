module convolve #(
    parameters
) (
    input i_clk,
    input start,
    input stride,
    input [BIT_DEPTH-1:0] i_kernel_data,
    input [BIT_DEPTH-1:0] i_row1_data;
    input [BIT_DEPTH-1:0] i_row2_data,
    input [BIT_DEPTH-1:0] i_row3_data,
    output reg [BIT_DEPTH:0] sum_of_products,
    output reg [BIT_DEPTH-1:0] dest_address,
    output reg [BIT_DEPTH-1:0] dest_wr_en,
    output reg done

);
    
endmodule