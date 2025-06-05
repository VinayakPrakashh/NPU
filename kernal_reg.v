module kernal_reg #(
    parameter KERNEL_SIZE = 3,
    parameter KERNEL_ADDR_WIDTH = 5,
    parameter WEIGHT_WIDTH = 8,

) (
    input i_clk,
    input i_rst,
    input wr_en,
    input [KERNEL_ADDR_WIDTH-1:0] wr_addr, // address to write to the kernel
    input [KERNEL_ADDR_WIDTH-1:0] rd_addr, // address to read from the kernel
    input [WEIGHT_WIDTH-1:0] wr_data, // data to write to the kernel
    output reg [WEIGHT_WIDTH-1:0] rd_data, // data read from the kernel);
);

reg [7:0] kernal [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Kernel buffer

always @(posedge clk) begin
    if(wr_en) begin
        kernal[wr_addr] <= wr_data; // Write data to kernel
    end
end

assign rd_data = kernal[rd_addr]; // Read data from kernel

endmodule