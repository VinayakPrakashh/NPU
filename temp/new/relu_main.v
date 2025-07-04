module relu_main #(
    parameter BIT_DEPTH = 8, // Width of the data stored in LineBuffer
    parameter DEST_ADDR_WIDTH = 10 // Address width for destination
    ) (
    input clk,
    input rst,
    input start,
    input [1:0] stride, //only stride 1 and 2 are supported
    input [BIT_DEPTH-1:0] in_data1, // Input data from LineBuffer row 1
    input [BIT_DEPTH-1:0] in_data2, // Input data from Line
    input [DEST_ADDR_WIDTH-1:0] in_dest_addr1, // Input destination address
    input [DEST_ADDR_WIDTH-1:0] in_dest_addr2, // Input destination address
    output reg wr_en, // Shift enable signal for LineBuffer
    output reg [DEST_ADDR_WIDTH-1:0] out_dest_addr1, // Address for writing to destination
    output reg [DEST_ADDR_WIDTH-1:0] out_dest_addr2, // Address for writing to destination
    output reg [BIT_DEPTH-1:0] out_data1, // Output data from ReLU operation
    output reg [BIT_DEPTH-1:0] out_data2 // Output data from ReLU operation
);

reg [2:0] state, next_state;
parameter IDLE = 3'b000, RELU = 3'b001, WRITE_BACK = 3'b010, DONE = 3'b011;
reg [BIT_DEPTH-1:0] relu_in1,relu_in2; // Input data to be processed
wire [BIT_DEPTH-1:0] relu_out1,relu_in2; // Output data after ReLU operation
always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= IDLE; // Reset state to IDLE
    end else begin
        state <= next_state; // Update state
    end
end
always @(*) begin
    case(state)
    IDLE: begin
        if(start) begin
            next_state = RELU; // Transition to RELU state on start signal
        end else begin
            next_state = IDLE; // Stay in IDLE state
        end
    end
    RELU : begin

    end 
    endcase
end
always @(posedge clk) begin
    IDLE: begin
        wr_en <= 1'b0; // Disable write enable in IDLE state
        out_dest_addr1 <= in_dest_addr1; // Set output destination address 1
        out_dest_addr2 <= in_dest_addr2; // Set output destination address 2
        relu_in1 <= 0; // Reset input data for ReLU 
        relu_in2 <= 0; // Reset input data for ReLU
        wr_en <= 1'b0; // Disable write enable

    end
    RELU: begin
        relu_in1 <= in_data1; // Pass output of ReLU operation to input for next cycle
        relu_in2 <= in_data2; // Pass output of ReLU operation to input for next cycle
        counter  <= counter + 1; // Increment counter for next operation
        if(counter == 1) begin 
            counter <= 0; // Reset counter after processing
        end
    end
    WRITE_BACK: begin
            counter <= counter + 1; // Increment counter
            wr_en <= 1'b1; // Enable write back
            out_data1 <= relu_out1; // Output ReLU result 1
            out_data2 <= relu_out2; // Output ReLU result 2 
            if (counter == 1) begin
                out_data1 <= 0;
                out_data2 <= 0; // Reset output data after write back
                wr_en <= 1'b0; // Disable write enable after write back
                counter <= 0; // Reset counter for next operation
            end
            end
    DONE: begin
        wr_en <= 1'b0; // Disable write enable in DONE state
    end
end

relu #(
    .BIT_DEPTH(BIT_DEPTH)
) relu_inst (
    .din(relu_in1), // Input data to be processed
    .dout(relu_out1) // Output data after ReLU operation
);
relu #(
    .BIT_DEPTH(BIT_DEPTH)
) relu_inst2 (
    .din(relu_in2), // Input data to be processed
    .dout(relu_out2) // Output data after ReLU operation
);
endmodule

