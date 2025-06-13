module mux_3_1 #(
    parameter BIT_DEPTH = 8 // Width of the data stored in BRAM
) (
    input [BIT_DEPTH-1:0] in1,
    input [BIT_DEPTH-1:0] in2,
    input [BIT_DEPTH-1:0] in3,
    input [1:0] sel,
    output [BIT_DEPTH-1:0] out
);

    // Mux logic: if sel is 0, output in1; if sel is 1, output in2
    assign out = (sel == 3'b01) ? in1 :
                 (sel == 3'b10) ? in2 :
                 (sel == 3'b11) ? in3 : 8'b0; // Default to in1 if sel is invalid

endmodule
