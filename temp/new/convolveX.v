module convolve #(
    parameter BIT_DEPTH = 8
) (
input clk,
    input rst,
    input start,
    input [1:0] stride,
    input [7:0] in_l1,
    input [7:0] in_l2,
    input [7:0] in_l3,
    input [7:0] kernel_in,
    output reg [3:0] kernel_addr,
    output reg shift_buffer,
    output reg done
    output [7:0] sum1,
    output [7:0] sum2

);

reg [2:0] state, next_state;
parameter IDLE = 3'b000, INITIAL_LOAD = 3'b001, LOAD = 3'b010, CONVOLVE = 3'b011,
          DONE = 3'b100;

reg window_en;

reg [3:0] counter;
wire [7:0] w2_r1_col1, w2_r1_col2, w2_r1_col3,
           w2_r2_col1, w2_r2_col2, w2_r2_col3,
           w2_r3_col1, w2_r3_col2, w2_r3_col3;
wire [7:0] window1_out1, window1_out2, window1_out3;
wire [7:0] link_wire1, link_wire2, link_wire3;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end
always @(*) begin
    case (state)
        IDLE: begin
            if (start) begin
                next_state = INITIAL_LOAD;
            end else begin
                next_state = IDLE;
            end
        end
        INITIAL_LOAD: begin
            if (counter == (stride + 3)) begin // Adjusted for stride
                next_state = CONVOLVE;
            end else begin
                next_state = INITIAL_LOAD; // Stay in LOAD state until counter reaches stride + 3
            end
        end
        LOAD: begin

        end
        CONVOLVE: begin
            if(counter == 3) begin // Assuming we want to convolve for 3 cycles
                next_state = DONE; // Move to DONE state after convolution
            end else begin
                next_state = CONVOLVE; // Stay in CONVOLVE state until done
            end
        end
        DONE: begin
            done = 1; // Indicate that the operation is done
            next_state = IDLE; // Return to IDLE state after completion
        end
        default: next_state = IDLE;
    endcase
end
always @(posedge clk) begin
    case (state)
    IDLE: begin
        shift_buffer <= 0; // Reset shift buffer
        done <= 0; // Reset done signal
        window_en <= 0; // Disable window
        counter <= 0; // Reset counter
    end
    INITIAL_LOAD: begin
        counter <= counter + 1; // Increment counter for loading data
        shift_buffer <= 1; // Enable shift buffer to load data
        window_en <= 1; // Enable window for initial load
        if (counter == (stride + 3)) begin
            shift_buffer <= 0; // Disable shift buffer after loading
            window_en <= 0; // Disable window after initial load
            counter <= 0; // Reset counter for next state
        end
    end
    CONVOLVE: begin
        counter <= counter + 1; // Increment counter for convolution cycles
        kernel_shift <= 1; // Enable kernel shift for convolution
        
        if (counter == 3) begin
            counter <= 0; // Reset counter after convolution cycles
            kernen_en <= 0; // Disable kernel shift after convolution
        end
    end
    DONE: begin
        done <= 1; // Set done signal to indicate completion
    end
    endcase
end

mux_3_1 #( // mux to select the first column for stride 1
    .BIT_DEPTH(8)
) mux1 (
    .in1(w1_r1_col1),
    .in2(w1_r1_col2),
    .in3(w1_r1_col3),
    .sel(stride),
    .out(link_wire1)
);
mux_3_1 #( //mus to select the second column for stride 2
    .BIT_DEPTH(8)
) mux2 (
    .in1(w1_r2_col1),
    .in2(w1_r2_col2),
    .in3(w1_r2_col3),
    .sel(stride),
    .out(link_wire2)
);
mux_3_1 #( // mux to select he third column for stride 3
    .BIT_DEPTH(8)
) mux3 (
    .in1(w1_r3_col1),
    .in2(w1_r3_col2),
    .in3(w1_r3_col3),
    .sel(stride),
    .out(link_wire3)
);
window2 #( //window2
    .BIT_DEPTH(8)
) w2 (
    .clk(clk),
    .rst(rst),
    .wr_sft_en(window_en),
    .in_l1(in_l1),
    .in_l2(in_l2),
    .in_l3(in_l3),
    .r1_col1(w2_r1_col1),
    .r1_col2(w2_r1_col2),
    .r1_col3(w2_r1_col3),
    .r2_col1(w2_r2_col1),
    .r2_col2(w2_r2_col2),
    .r2_col3(w2_r2_col3),
    .r3_col1(w2_r3_col1),
    .r3_col2(w2_r3_col2),
    .r3_col3(w2_r3_col3)
);
window1 #( //window1
    .BIT_DEPTH(8)
) w1 (
    .clk(clk),
    .wr_en(window_en),
    .in1(link_wire1),
    .in2(link_wire2),
    .in3(link_wire3),
    .out1(window1_out1),
    .out2(window1_out2),
    .out3(window1_out3)
);

endmodule
