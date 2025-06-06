
module top(
    input clk,
    input rst,
    input [9:0] i_src1_start_addr,
    input [9:0] i_kernal_start_addr,
    input i_start,
    input [2:0] i_stride,
    output o_done,
    output [7:0] o_sum1,
    output [7:0] o_sum2
);

    wire [7:0] i_src1_data1, i_src1_data2;
    wire [9:0] dest_address1, dest_address2;
    wire [9:0] src1_addr1, src1_addr2;
    // Instantiate the RAM module
    // ram #(
    //     .ROWS(28),
    //     .COLS(28)
    // ) ram_inst (
    //     .clk(clk),
    //     .rst(rst),
    //     .wr_en(1'b0), // Assuming write enable is always high for this example
    //     .data_in(0), // Example data input
    //     .wr_addr(0), // Example write address
    //     .rd_addr1(src1_addr1), // Read address 1
    //     .rd_addr2(src1_addr2), // Read address 2
    //     .data_out1(i_src1_data1), // Output data 1
    //     .data_out2(i_src1_data2)  // Output data 2
    // );

    // // Instantiate the convolve module
    // convolve convolve_inst (
    //     .i_clk(clk),
    //     .i_rst(rst),
    //     .i_start(i_start),
    //     .i_src1_data1(i_src1_data1),
    //     .i_src1_data2(i_src1_data2),
    //     .i_src1_start_addr(i_src1_start_addr),
    //     .i_kernal_start_addr(i_kernal_start_addr),
    //     .dest_address1(dest_address1),
    //     .dest_address2(dest_address2),
    //     .i_stride(i_stride),
    //     .o_sum1(o_sum1),
    //     .o_sum2(o_sum2),
    //     .o_done(o_done),
    //     .src1_addr2(src1_addr2),
    //     .src1_src2_addr1(src1_addr1)
    // );

convolveX #(
        .KERNEL_SIZE(3),
        .DATA_WIDTH(8),
        .SRAM_ADDR_WIDTH(4),
        .SRAM_DEPTH(16)
    ) convolveX_inst (
        .i_clk(clk),
        .i_rst(rst),
        .i_start(i_start),
        .i_window1_addr(src1_addr1[3:0]), // Example address mapping
        .i_window1_data(i_src1_data1),
        .i_window2_addr(src1_addr2[3:0]), // Example address mapping
        .i_window2_data(i_src1_data2),
        .o_kernel_addr(dest_address1[3:0]), // Example address mapping
        .i_kernel_data(0), // Example kernel data
        .o_result(o_sum1), // Result of the convolution operation
        .o_done(o_done) // Signal indicating the convolution operation is done
    );

endmodule
module convolveX #(
    parameter KERNEL_SIZE = 3, // Size of the kernel
    parameter DATA_WIDTH = 8, // Width of the data
    parameter SRAM_ADDR_WIDTH = 4, // Address width for SRAM
    parameter SRAM_DEPTH = 16 // Depth of the SRAM
) (
    input i_clk,
    input i_rst,
    input i_start, // Signal to start the convolution operation
    output reg [SRAM_ADDR_WIDTH-1:0] i_window1_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window1_data, // Data read from SRAM
    output reg [SRAM_ADDR_WIDTH-1:0] i_window2_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window2_data, // Data read from SRAM
    output reg [SRAM_ADDR_WIDTH-1:0] o_kernel_addr, // Address to write the kerne
    input [DATA_WIDTH-1:0] i_kernel_data, // Kernel data for convolution
    output reg [DATA_WIDTH-1:0] o_result, // Result of the convolution operation
    output reg o_done // Signal indicating the convolution operation is done
);
