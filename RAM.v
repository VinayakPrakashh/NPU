module ram #(
    parameter ROWS = 28,
    parameter COLS = 28
) (
    input clk,
    input rst,
    input wr_en,
    input [7:0] data_in,
    input [9:0] wr_addr,
    input [9:0] rd_addr1,
    input [9:0] rd_addr2,
    output  [7:0] data_out1,
    output  [7:0] data_out2

);
    
reg [7:0] ram [ROWS*COLS-1:0];

always @(posedge clk) begin

    if (wr_en) begin
        ram[wr_addr] <= data_in;
    end
end
   assign data_out1 = ram[rd_addr1];
   assign data_out2 = ram[rd_addr2];
endmodule