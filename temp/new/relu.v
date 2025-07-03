module relu #(
    parameter BIT_DEPTH = 8
) (
    input [BIT_DEPTH-1:0] din,
    output [BIT_DEPTH-1:0] dout
);
    // ReLU operation: output is max(0, input)
    assign dout = (din < 0) ? 0 : din;


endmodule