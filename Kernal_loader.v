module load_kernal #(
    parameter KERNEL_REG_ADDR_WIDTH = 5, //3*3 kernal
    parameter BRAM_ADDR_WIDTH = 10, // 28*28 for input image
    parameter WEIGHT_WIDTH = 8
) (
    input i_clk,
    input i_rst,
    input i_start,
    input [5:0] i_kernal_element_size, // Size of the kernel (3x3, 5x5, etc.)
    input [BRAM_ADDR_WIDTH-1:0] i_kernal_start_addr,
    input [WEIGHT_WIDTH-1:0] i_kernal_data, // Data to write to the kernel
    output reg wr_en, // Write enable signal for the kernel
    output reg [BRAM_ADDR_WIDTH-1:0] o_bram_address, // Address to read the kernel from BRAM
    output reg [KERNEL_REG_ADDR_WIDTH-1:0] o_kernal_reg_addr, // Address to read the kernel
    output [WEIGHT_WIDTH-1:0] o_kernal_data, // Data read from the kernel
    output reg o_done // Signal indicating the kernel loading is done
);

parameter IDLE = 2'b00, LOAD_KERNEL = 2'b01, DONE = 2'b10;
reg [1:0] state;
always @(posedge i_rst or posedge i_clk) begin
    if(i_rst) begin
        state <= IDLE; // Reset state to IDLE on reset
    end else begin
    case(state)
    IDLE: begin
        if (i_start) begin
            state <= LOAD_KERNEL;
            wr_en <= 1'b1; // Enable writing to kernel
            o_bram_address <= i_kernal_start_addr; // Start address for kernel data
        end else begin
            state <= IDLE;
            wr_en <= 1'b0; // Disable writing to kernel
            o_bram_address <= 0; // Reset address
            o_done <= 1'b0; // Reset done signal
            o_kernal_reg_addr <= 0; // Reset kernel register address
        end
    end
    LOAD_KERNEL: begin
        o_kernal_reg_addr <= o_kernal_reg_addr + 1; // Set kernel register address
        o_bram_address <= o_bram_address + 1; // Increment BRAM address
        if(o_kernal_reg_addr == i_kernal_element_size-1) begin
            state <= DONE;
            wr_en <= 1'b0; // Disable writing to kernel
            o_kernal_reg_addr <= 0; // Reset kernel register address
            o_bram_address <= 0; // Reset BRAM address
        end else begin
            state <= LOAD_KERNEL; // Continue loading kernel data
        end
    end

    DONE: begin
        
        o_done <= 1'b1; // Set done signal
        state <= IDLE; // Reset state to idle for next operation

    end
    default: begin
        state <= IDLE; // Default case to handle unexpected states
    end
    endcase
    end
end
assign o_kernal_data =  i_kernal_data; // Output kernel data when writing
endmodule