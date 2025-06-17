module kernel_reg #(
    parameter BIT_DEPTH = 8, // Width of the data stored in kernel_reg
    parameter KERNEL_SIZE = 3 // Size of the kernel (3x3)
) (
    input clk,
    input [BIT_DEPTH-1:0] kernel_in,
    input wr_en, // Write enable signal
    output [BIT_DEPTH-1:0] kernel_out,
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

initial begin
    kernel_buffer[0] = 8'd0;  // Position [0,0]
    kernel_buffer[1] = 8'd0;  // Position [0,1]
    kernel_buffer[2] = 8'd0;  // Position [0,2]
    kernel_buffer[3] = 8'd0;  // Position [1,0]
    kernel_buffer[4] = 8'd0;  // Position [1,1]
    kernel_buffer[5] = 8'd0;  // Position [1,2]
    kernel_buffer[6] = 8'd0;  // Position [2,0]
    kernel_buffer[7] = 8'd0;  // Position [2,1]
    kernel_buffer[8] = 8'd3;  // Position [2,2]
end

endmodule