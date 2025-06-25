`timescale 1ns / 1ps
module comparator1 (
    input  [7:0] a,
    input  [7:0] b,
    input        en,
    input        sel,
    output wire [7:0] out
);

  assign out = en ? ((sel) ? ((a >= b) ? a : b) : ((a <= b) ? a : b)) : 8'd0;

endmodule