module mux_9_1 #(
    parameter BIT_DEPTH = 8
) (
    input  [BIT_DEPTH-1:0] in1,
    input  [BIT_DEPTH-1:0] in2,
    input  [BIT_DEPTH-1:0] in3,
    input  [BIT_DEPTH-1:0] in4,
    input  [BIT_DEPTH-1:0] in5,
    input  [BIT_DEPTH-1:0] in6,
    input  [BIT_DEPTH-1:0] in7,
    input  [BIT_DEPTH-1:0] in8,
    input  [BIT_DEPTH-1:0] in9,
    input  [3:0] sel,
    output [BIT_DEPTH-1:0] out
);

assign out = (sel == 4'd0) ? in1 :
             (sel == 4'd1) ? in2 :
             (sel == 4'd2) ? in3 :
             (sel == 4'd3) ? in4 :
             (sel == 4'd4) ? in5 :
             (sel == 4'd5) ? in6 :
             (sel == 4'd6) ? in7 :
             (sel == 4'd7) ? in8 :
             (sel == 4'd8) ? in9 :
             {BIT_DEPTH{1'b0}};

endmodule
