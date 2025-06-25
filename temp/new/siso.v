`timescale 1ns / 1ps
module siso #(
  parameter WIDTH = 8,
  parameter DEPTH = 26
)(
  input wire clk,
  input wire shift_en,
  input wire [WIDTH-1:0] din,
  output wire [WIDTH-1:0] dout
);

  reg [WIDTH-1:0] buffer [0:DEPTH-1];
  integer i;

  always @(posedge clk) begin
  if(shift_en)begin
    for (i = DEPTH-1; i > 0; i = i - 1)
        buffer[i] <= buffer[i-1];
    buffer[0] <= din;
    end
  end
assign dout=buffer[25];
endmodule