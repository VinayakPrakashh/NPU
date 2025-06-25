`timescale 1ns / 1ps
module main(
  input clk,
  input rst,
  input done,
  input [7:0] data1,
  input [7:0] data2,
  input pool_type,
  input en_comp1,
  input en_comp2,
  output  [7:0] rd_data
);
 wire [7:0] out1,shifted_out,comp_out;
 comparator1 pool_1 (
    .a(data1),
    .b(data2),
    .sel(pool_type),
    .en(en_comp1),
    .out(out1)
  );
  comparator1 pool_2 (
    .a(shifted_out),
    .b(out1),
    .sel(pool_type),
    .en(en_comp2),
    .out(comp_out)
  );
siso #(
  .WIDTH(8),
  .DEPTH(13)
) siso_inst (
  .clk(clk),
  .shift_en(en_comp1),    
  .din(out1),          
  .dout(shifted_out)      
);
siso #(
  .WIDTH(8),
  .DEPTH(13)
) siso_inst1 (
  .clk(clk),
  .shift_en(en_comp2),    
  .din(comp_out),          
  .dout(rd_data)      
);
always @(posedge clk)begin

end
endmodule