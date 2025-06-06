module convolve #(
    parameter KERNEL_SIZE = 3, // Size of the kernel
    parameter DATA_WIDTH = 8, // Width of the data
    parameter SRAM_ADDR_WIDTH = 4, // Address width for SRAM
    parameter SRAM_DEPTH = 16 // Depth of the SRAM
) (
    input i_clk,
    input i_rst,
    input i_start, // Signal to start the convolution operation
    input [SRAM_ADDR_WIDTH-1:0] i_window1_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window1_data, // Data read from SRAM
    input [SRAM_ADDR_WIDTH-1:0] i_window2_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window2_data, // Data read from SRAM
    input [DATA_WIDTH-1:0] i_kernel_data, // Kernel data for convolution
    output reg [DATA_WIDTH-1:0] o_result, // Result of the convolution operation
    output reg o_done // Signal indicating the convolution operation is done
);

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        o_result <= 0; // Reset result on reset
        o_done <= 0; // Reset done signal on reset
    end else if (i_start) begin
        // Perform convolution operation
        o_result <= (i_window1_data * i_kernel_data) + (i_window2_data * i_kernel_data);
        o_done <= 1; // Set done signal after operation
    end else begin
        o_done <= 0; // Clear done signal if not starting
    end

endmodule