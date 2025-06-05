module kerna_reg #(
    parameter KERNEL_SIZE = 3,
    parameter KERNEL_ADDR_WIDTH = 10,
    parameter WEIGHT_WIDTH = 8,

) (
    input i_clk,
    input i_rst,
    input i_start,
    input [KERNEL_ADDR_WIDTH-1:0] i_start_addr, // starting address of the kernel in BRAM0
    input [KERNEL_ADDR_WIDTH-1:0] i_src1_start_addr, // starting address of the source data in BRAM1
);
reg [7:0] kernal [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Kernel buffer


endmodule