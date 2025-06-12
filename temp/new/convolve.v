module convolve #(
    BIT_DEPTH = 8// Width of the data stored in BRAM
) (
    input clk,
    input rst,
    input start,
    input [1:0] stride,
    input [BIT_DEPTH-1:0] in_l1,
    input [BIT_DEPTH-1:0] in_l2,
    input [BIT_DEPTH-1:0] in_l3,
    output reg shift_buffer,
    output reg done
);
reg [2:0] state,next_state;
parameter IDLE = 3'b000, LOAD = 3'b001, CONVOLVE = 3'b010, DONE = 3'b011;
reg window1_en,window2_en;
reg [3:0] counter;
wire [7:0] w1_out_1, w1_out_2, w1_out_3;
wire [7:0] w2_out_1, w2_out_2, w2_out_3;
always @(posedge clk) begin
    if(rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if(start)   begin
                // Transition to LOAD state when start signal is high
                next_state = LOAD;
            end else begin
                next_state = IDLE; // Stay in IDLE state if not started
            end
        end
        LOAD: begin
            if(counter == ( stride + 3 )) begin //if stride is 1 then 4, if stride is 2 then 5, etc.
                next_state = CONVOLVE;
            end
            else begin
                next_state = LOAD; // Stay in LOAD state until counter reaches stride+3
            end
        end
        CONVOLVE: begin
            // Perform convolution operation
            next_state = DONE;
        end
        DONE: begin
            // Indicate that the operation is done
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end
always @(posedge clk) begin
    IDLE: begin
        shift_buffer <= 0; // Reset shift buffer
        done <= 0; // Reset done signal
        window1_en <= 0; // Disable window1
        window2_en <= 0; // Disable window2
        counter <= 0; // Reset counter
    end
    LOAD: begin
        counter <= counter + 1; // Increment counter for loading data
        shift_buffer <= 1; // Enable shift buffer to load data
        if(counter == stride) begin
            window2_en <= 1;
        end
        if(counter < 2) begin
            window1_en <= 1; // Enable window1 for loading data
        end else begin
            window1_en <= 0; // Disable window1 after first load
        end
    end

end

window1 #(
    .BIT_DEPTH(BIT_DEPTH)
) window1_inst (
    .clk(clk),
    .wr_en(window1_en),
    .in1(in_l1),
    .in2(in_l2),
    .in3(in_l3),
    .out1(w1_out_1),
    .out2(w1_out_2),
    .out3(w1_out_3)
);
window2 #(
    .BIT_DEPTH(BIT_DEPTH)
) window2_inst (
    .clk(clk),
    .wr_en(window2_en),
    .in1(in_l1),
    .in2(in_l2),
    .in3(in_l3),
    .out1(w2_out_1),
    .out2(w2_out_2),
    .out3(w2_out_3)
);

endmodule