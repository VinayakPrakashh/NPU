module top #(
    parameter BIT_DEPTH = 8,
	 parameter COLS = 28
) (
    input clk,
    start,
    input rst,
    input [1:0] stride,
    input wr_en, // Write enable signal for line buffer
    output done
);
    wire [BIT_DEPTH-1:0] in_l1, in_l2, in_l3; // Inputs to the convolution module
    wire [BIT_DEPTH-1:0] out_l1, out_l2, out_l3; // Outputs from the convolution module
    wire shift_buffer; // Signal to shift the buffer

    // Instantiate the line buffer
    linebuffer #(
        .BIT_DEPTH(BIT_DEPTH),
        .COLS(COLS)
    ) lb (
        .clk(clk),
        .wr_en(wr_en),
        .shift(shift_buffer),
        .data_in_r1(in_l1),
        .data_in_r2(in_l2),
        .data_in_r3(in_l3),
        .rd_data_r1(out_l1),
        .rd_data_r2(out_l2),
        .rd_data_r3(out_l3)
    );

    // Instantiate the convolution module
    convolve #(
        .BIT_DEPTH(BIT_DEPTH)
    ) conv (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stride(stride),
        .in_l1(out_l1),
        .in_l2(out_l2),
        .in_l3(out_l3),
        .shift_buffer(shift_buffer),
        .done(done)
		  );

endmodule
