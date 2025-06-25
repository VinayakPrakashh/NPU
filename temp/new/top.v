module top #(
    parameter BIT_DEPTH = 8 // Width of the data stored in LineBuffer

) (
    input clk,
    input rst,
    input start,
    input pool_type,
    input pool_en,
    input [1:0] stride,
    output  shift_buffer,
    output done,
    output [BIT_DEPTH-1:0] sum1,
    output [BIT_DEPTH-1:0] sum2,
    output [BIT_DEPTH-1:0] sum_out,
    output [4:0] out_dest_addr,
    output dest_wr_en, // Write enable for destination
    output rd_data
);
wire comp1_en,comp2_en;
wire [BIT_DEPTH-1:0] in_l1, in_l2, in_l3; // Inputs from LineBuffer
wire [3:0] kernel_addr; // Kernel address output
wire [BIT_DEPTH-1:0] kernel_data; // Kernel data output
main main1(.clk(clk),
      .rst(rst),
       .data1(sum1),
       .data2(sum2),
       .pool_type(pool_type),
       .en_comp1(comp1_en),
       .en_comp2(comp2_en),
       .rd_data(rd_data)
);

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
    .pool_en(pool_en), // Enable signal for pooling operation
    .stride(stride),
    .in_l1(in_l1), // Input from LineBuffer row 1
    .in_l2(in_l2), // Input from LineBuffer row 2
    .in_l3(in_l3), // Input from LineBuffer row 3
    .kernel_in(kernel_data), // Kernel data input
    .in_dest_addr(5'b00000), // Placeholder for input destination address
    .kernel_addr(kernel_addr), // Kernel address output
    .shift_buffer(shift_buffer), // Shift enable signal for LineBuffer
    .done(done), // Done signal
    .sum1(sum1), // Output sum 1
    .sum2(sum2), // Output sum 2
    .dest_wr_en(dest_wr_en), // Write enable for destination
    .out_dest_addr(out_dest_addr), // Address for writing to destination
    .sum_out(sum_out), // Output sum
    .comp1_en(comp1_en), // Placeholder for comparator 1 enable signal
    .comp2_en(comp2_en)  // Placeholder for comparator 2 enable signal
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
