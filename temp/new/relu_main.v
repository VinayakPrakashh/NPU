module relu_main #(
    parameter BIT_DEPTH = 8, // Width of the data stored in LineBuffer
    parameter DEST_ADDR_WIDTH = 10 // Address width for destination
    ) (
    input clk,
    input rst,
    input start,
    input [1:0] stride, //only stride 1 and 2 are supported
    input [DEST_ADDR_WIDTH-1:0] in_dest_addr1, // Input destination address
    input [DEST_ADDR_WIDTH-1:0] in_dest_addr2, // Input destination address
    output reg wr_en, // Shift enable signal for LineBuffer
    output reg [DEST_ADDR_WIDTH-1:0] out_dest_addr1, // Address for writing to destination
    output reg [DEST_ADDR_WIDTH-1:0] out_dest_addr2, // Address for writing to destination
);

reg [2:0] state, next_state;
parameter IDLE = 3'b000, RELU = 3'b001, WRITE_BACK = 3'b010, DONE = 3'b011;

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
relu #(
    .BIT_DEPTH(BIT_DEPTH)
) relu_inst (
    .din(relu_in), // Input data to be processed
    .dout(relu_out) // Output data after ReLU operation
);
endmodule

