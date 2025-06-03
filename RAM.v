module ram #(
    ROWS = 28,
    COLS = 28
) (
    input clk,
    input rst,
    input wr_en
    input [7:0] data_in,
    input [9:0] rd_addr1,
    input [9:0] rd_addr2,
    output  [7:0] data_out1,
    output  [7:0] data_out2

);
    
reg [7:0] ram [ROWS*COLS-1:0]

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out1 <= 0;
        data_out2 <= 0;
    end else begin
    if (wr_en) begin
        ram[rd_addr1] <= data_in;
    end
end
end
    data_out1 = ram[rd_addr1];
    data_out2 = ram[rd_addr2];
endmodule