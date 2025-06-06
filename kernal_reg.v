module kernal_reg #(
    parameter KERNEL_REG_SIZE = 64,
    parameter KERNEL_ADDR_WIDTH = 6,
    parameter WEIGHT_WIDTH = 8

) (
    input i_clk,
    input i_rst,
    input wr_en,
    input [KERNEL_ADDR_WIDTH-1:0] wr_addr, // address to write to the kernel
    input [KERNEL_ADDR_WIDTH-1:0] rd_addr, // address to read from the kernel
    input [WEIGHT_WIDTH-1:0] wr_data, // data to write to the kernel
    output [WEIGHT_WIDTH-1:0] rd_data // data read from the kernel);
);

reg [7:0] kernal [KERNEL_REG_SIZE-1:0]; // Kernel buffer

always @(posedge i_clk) begin
    if(wr_en) begin
        kernal[wr_addr] <= wr_data; // Write data to kernel
    end
end

assign rd_data = kernal[rd_addr]; // Read data from kernel
initial begin
    kernal[0] = 3;
    kernal[1] = 1;
    kernal[2] = 5;
    kernal[3] = 2;
    kernal[4] = 4;
    kernal[5] = 2;
    kernal[6] = 5;
    kernal[7] = 1;
    kernal[8] = 3;
    // The rest can be zero or left uninitialized
end
endmodule