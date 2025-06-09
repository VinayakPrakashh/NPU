module LUTRAM2 #(
    BIT_DEPTH = 8, // Width of the data stored in LUTRAM
    ADDR_WIDTH = 10, // Address width for LUTRAM
    DEPTH = 784 // Depth of the LUTRAM
) (
    input clk,
    input wr_en, // Write enable signal
    input [ADDR_WIDTH-1:0] wr_addr, // Address to write to LUTRAM
    input [BIT_DEPTH-1:0] data_in, // Data to write to LUTRAM
    input [ADDR_WIDTH-1:0] rd_addr, // Address to read from LUTRAM
    output [BIT_DEPTH-1:0] data_out // Data read from LUTRAM
);

reg [BIT_DEPTH-1:0] LUTRAM [DEPTH-1:0]; // LUTRAM memory array

always @(posedge clk) begin
    if (wr_en) begin
        LUTRAM[wr_addr] <= data_in; // Write data to LUTRAM
    end
end

assign data_out = LUTRAM[rd_addr]; // Read data from LUTRAM

endmodule