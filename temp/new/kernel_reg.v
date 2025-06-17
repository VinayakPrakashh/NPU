module kernel_reg #(
    parameter BIT_DEPTH = 8, // Width of the data stored in kernel_reg
    parameter KERNEL_SIZE = 3 // Size of the kernel (3x3)
) (
    input clk,
    input [BIT_DEPTH:0] kernel_in,
    input wr_en, // Write enable signal
    output reg [BIT_DEPTH:0] kernel_out,
    input [3:0] kernel_addr // Address for reading the kernel
);

reg [7:0] kernel_buffer [0:KERNEL_SIZE*KERNEL_SIZE-1]; // Kernel memory array

wire [7:0] in;
always @(posedge clk ) begin
if(wr_en) begin
    kernel_buffer[kernel_addr] <= kernel_in; // Write to the kernel memory
    end
end

assign kernel_out = kernel_buffer[kernel_addr]; // Read from the kernel memory


endmodule