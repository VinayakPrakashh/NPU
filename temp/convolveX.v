module convolveX #(
    parameter KERNEL_SIZE = 3, // Size of the kernel
    parameter DATA_WIDTH = 8, // Width of the data
    parameter SRAM_ADDR_WIDTH = 4, // Address width for SRAM
    parameter SRAM_DEPTH = 16 // Depth of the SRAM
) (
    input i_clk,
    input i_rst,
    input i_start, // Signal to start the convolution operation
    output reg [SRAM_ADDR_WIDTH-1:0] o_window_addr, // Address to read from SRAM
    input [DATA_WIDTH-1:0] i_window1_data, // Data read from SRAM
    input [DATA_WIDTH-1:0] i_window2_data, // Data read from SRAM
    output reg [5:0] o_kernel_addr, // Address to write the kerne
    input [DATA_WIDTH-1:0] i_kernel_data, // Kernel data for convolution
    output reg [DATA_WIDTH-1:0] o_result, // Result of the convolution operation
    output reg o_done // Signal indicating the convolution operation is done
);

parameter IDLE = 3'b000, LOAD_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, CALCULATE = 3'b011, WRITE_RESULT = 3'b100,DONE = 3'b101;

reg [2:0] state, next_state;
reg[3:0] i;

reg [7:0] kernel [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Kernel storage
reg [3:0] kernal_addr,window_addr; // Address for kernel storage
reg [7:0] window1 [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Window 1 storage
reg [7:0] window2 [KERNEL_SIZE*KERNEL_SIZE-1:0]; // Window 2 storage
reg [15:0] sum1, sum2; // Sum for convolution results

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
    LOAD_WINDOWS: begin
        if (o_window_addr == KERNEL_SIZE * KERNEL_SIZE - 1) begin
            next_state <= CALCULATE; // Transition to CALCULATE state
        end else begin
            next_state <= LOAD_WINDOWS; // Continue loading window data
        end
    end
    CALCULATE: begin
        if (i == 9) begin
            next_state <= DONE;
            
        end else begin
            next_state <= CALCULATE; // Continue calculating convolution
        end
    end
    DONE: begin
        next_state <= IDLE; // Reset state to IDLE for next operation
    end
    endcase
end

always @(posedge i_clk) begin
    case(state)
    IDLE : begin
        o_done <= 1'b0; // Reset done signal
        o_kernel_addr <= 0; // Reset kernel address
        kernal_addr <= 0; // Reset kernel address
        window_addr <= 0; // Reset window address
        o_window_addr <= 0; // Reset output window address
        sum1 <= 0; // Reset sum1
        sum2 <= 0; // Reset sum2
        i <= 0; // Reset index for convolution
        
    end
    LOAD_KERNEL: begin
        kernal_addr <= kernal_addr + 1; // Increment kernel address
        o_kernel_addr <= o_kernel_addr + 1; // Increment kernel address
        kernel[kernal_addr] <= i_kernel_data; // Store kernel data
    end
    LOAD_WINDOWS: begin
        window_addr <= window_addr + 1; // Increment window address
        o_window_addr <= o_window_addr + 1; // Update output window address
        window1[window_addr] <= i_window1_data; // Store window1 data
        window2[window_addr] <= i_window2_data; // Store window2 data
        end
    CALCULATE: begin
        i <= i + 1; // 
        sum1 <= sum1 + window1[i] * kernel[i]; // Perform convolution operation
        sum2 <= sum2 + window2[i] * kernel[i]; // Perform convolution operation
    end
    DONE : begin 
        i <= 0; 
        o_done <= 1'b1; // Set done signal    
            end
    endcase
end
endmodule