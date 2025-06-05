module npt_top (
    input i_clk,
    input i_rst,
    input i_start,
    output o_done
);

wire [7:0] i_kernal_data; // Data read from BRAM
wire [9:0] bram_rd_addr; // Address to read from BRAM
wire wr_en_kernal; // Write enable signal for the kernel
wire [5:0] kernal_reg_wr_address; // Address to write to the kernel
wire [7:0] kernal_data; // Data read from the kernel
wire [7:0] rd_data_kernal; // Data read from the kernel
// Instantiate the modules
bram0 #(
    .BRAM_ADDR_WIDTH(10),
    .WEIGHT_WIDTH(8),
    .BRAM_DEPTH(28*28)
) bram_inst (
    .i_clk(i_clk),
    .wr_en(1'b0), // Write enable signal
    .wr_addr(10'b0), // Write address
    .wr_data(8'b0), // Data to write
    .rd_addr(bram_rd_addr), // Read address
    .rd_data(i_kernal_data) // Data read from BRAM
);
load_kernal #(
    .KERNEL_REG_ADDR_WIDTH(6), // 3x3 kernel
    .BRAM_ADDR_WIDTH(10), // 28x28 for input image
    .WEIGHT_WIDTH(8)
) load_kernal_inst (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_start(i_start),
    .i_kernal_element_size(9), // Example size for kernel
    .i_kernal_start_addr(10'b0000000000), // Example start address
    .i_kernal_data(i_kernal_data), // Example data to write to the kernel
    .wr_en(wr_en_kernal), // Write enable signal for the kernel
    .o_bram_address(bram_rd_addr), // Address to read the kernel from BRAM
    .o_kernal_reg_addr(kernal_reg_wr_address), // Address to read the kernel
    .o_kernal_data(kernal_data), // Data read from the kernel
    .o_done(o_done) // Signal indicating the kernel loading is done
);
kernal_reg #(
    .KERNEL_REG_SIZE(64),
    .KERNEL_ADDR_WIDTH(6),
    .WEIGHT_WIDTH(8)
) kernal_reg_inst (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .wr_en(wr_en_kernal), // Write enable signal
    .wr_addr(kernal_reg_wr_address), // Address to write to the kernel
    .rd_addr(6'b0), // Address to read from the kernel
    .wr_data(kernal_data), // Data to write to the kernel
    .rd_data(rd_data_kernal) // Data read from the kernel
);

endmodule
