module top #(
    parameter BIT_DEPTH = 8 // Width of the data stored in LineBuffer

) (
    input clk,
    input rst,
    input start,
    input [1:0] stride,
    output reg shift_buffer,
    output done
);

wire [BIT_DEPTH-1:0] in_l1, in_l2, in_l3; // Inputs from LineBuffer
wire shift_buffer; // Shift enable signal for LineBuffer
LineBuffer #(
    .BIT_DEPTH(BIT_DEPTH),
    .ROWS(3),
    .COLS(28)
) line_buffer (
    .clk(clk),
    .wr_en(0), // Write enable signal
    .shift(shift_buffer), // Shift enable signal
    .data_in_r1(8'h00), // Placeholder for data input row 1
    .data_in_r2(8'h00), // Placeholder for data input row 2
    .data_in_r3(8'h00), // Placeholder for data input row 3
    .rd_data_r1(in_l1), // Read data from LineBuffer row 1
    .rd_data_r2(in_l2), // Read data from LineBuffer row 2
    .rd_data_r3(in_l3)  // Read data from LineBuffer row 3
);
convolve #(
    .BIT_DEPTH(BIT_DEPTH)
) convolve_inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .stride(stride),
    .in_l1(in_l1),
    .in_l2(in_l2),
    .in_l3(in_l3),
    .kernel_in(kernel_data), // Placeholder for kernel input
    .kernel_addr(kernel_addr), // Kernel address output
    .shift_buffer(shift_buffer), // Shift enable signal for LineBuffer
    .done(done) // Done signal
);
kernel_reg #(
    .BIT_DEPTH(BIT_DEPTH),
    .KERNEL_SIZE(3)
) kernel_reg_inst (
    .clk(clk),
    .kernel_in(8'h00), // Placeholder for kernel input
    .wr_en(0), // Write enable signal
    .kernel_out(kernel_data), // Kernel output
    .kernel_addr(kernel_addr) // Kernel address input
);

endmodule
