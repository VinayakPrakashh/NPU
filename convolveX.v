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
    output reg [5:0] o_kernel_addr, // Address to write the kerne
    input [DATA_WIDTH-1:0] i_kernel_data, // Kernel data for convolution
    output reg [DATA_WIDTH-1:0] o_result, // Result of the convolution operation
    output reg o_done // Signal indicating the convolution operation is done
);

parameter IDLE = 3'b000, LOAD_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, CALCULATE = 3'b011, WRITE_RESULT = 3'b100;

reg [2:0] state, next_state;

reg [7:0] kernel [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Kernel storage
reg [3:0] kernal_addr; // Address for kernel storage
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        state <= IDLE; // Reset state to IDLE on reset
    end else begin
        state <= next_state; // Transition to the next state
    end
end

always @(*) begin
    case(state) 

    IDLE: begin
        if (i_start) begin
            next_state <= LOAD_KERNEL; // Transition to LOAD_KERNEL state
        end else begin
            next_state <= IDLE; // Stay in IDLE state
        end
    end
    LOAD_KERNEL: begin
    if (o_kernel_addr == KERNEL_SIZE * KERNEL_SIZE - 1) begin
        next_state <= LOAD_WINDOWS; // Continue loading kernel data
    end else begin
        next_state <= LOAD_KERNEL; // Transition to LOAD_WINDOWS state
    end
    end
    endcase
end

always @(posedge i_clk) begin
    case(state)
    IDLE : begin
        o_done <= 1'b0; // Reset done signal
        i_window1_addr <= 0; // Reset window1 address
        i_window2_addr <= 0; // Reset window2 address
        o_kernel_addr <= 0; // Reset kernel address
        kernal_addr <= 0; // Reset kernel address
    end
    LOAD_KERNEL: begin
        kernal_addr <= kernal_addr + 1; // Increment kernel address
        o_kernel_addr <= o_kernel_addr + 1; // Increment kernel address
        kernel[kernal_addr] <= i_kernel_data; // Store kernel data
    end
    endcase
    LOAD
end
endmodule