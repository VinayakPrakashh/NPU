module convolve #(
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
    input reg [SRAM_ADDR_WIDTH-1:0] i_window2_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window2_data, // Data read from SRAM
    output reg [SRAM_ADDR_WIDTH-1:0] o_kernel_addr, // Address to write the kerne
    input [DATA_WIDTH-1:0] i_kernel_data, // Kernel data for convolution
    output reg [DATA_WIDTH-1:0] o_result, // Result of the convolution operation
    output reg o_done // Signal indicating the convolution operation is done
);

parameter IDLE = 3'b000, LOAD_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, CALCULATE = 3'b011, WRITE_RESULT = 3'b100;

reg [2:0] state, next_state;

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        state <= IDLE; // Reset state to IDLE on reset
        o_done <= 1'b0; // Reset done signal
    end else begin
        state <= next_state; // Transition to the next state
    end
    else begin
        state <= next_state;
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
    end
    endcase
end

always @(posedge i_clk) begin
    case(state)
    IDLE
    endcase
end
endmodule