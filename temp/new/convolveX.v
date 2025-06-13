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
    output reg shift_buffer,
    output reg done

);

reg [2:0] state, next_state;
parameter IDLE = 3'b000, INITIAL_LOAD = 3'b001, LOAD = 3'b010, CONVOLVE = 3'b011,
          DONE = 3'b100;

reg window_en;
reg [3:0] counter;
wire [7:0] w1_r1_col1, w1_r1_col2, w1_r1_col3,
           w1_r2_col1, w1_r2_col2, w1_r2_col3,
           w1_r3_col1, w1_r3_col2, w1_r3_col3;

wire [7:0] link_wire1, link_wire2, link_wire3;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
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
    .r1_col1(w1_r1_col1),
    .r1_col2(w1_r1_col2),
    .r1_col3(w1_r1_col3),
    .r2_col1(w1_r2_col1),
    .r2_col2(w1_r2_col2),
    .r2_col3(w1_r2_col3),
    .r3_col1(w1_r3_col1),
    .r3_col2(w1_r3_col2),
    .r3_col3(w1_r3_col3)
);
window1 #( //window1
    .BIT_DEPTH(8)
) w1 (
    .clk(clk),
    .wr_en(window_en),
    .in1(link_wire1),
    .in2(link_wire2),
    .in3(link_wire3),
    .out1(w2_r1_col1),
    .out2(w2_r2_col1),
    .out3(w2_r3_col1)
);

endmodule
