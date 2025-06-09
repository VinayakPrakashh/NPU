module bram1 #(
    parameter BRAM_ADDR_WIDTH = 10, // Address width for BRAM
    parameter WEIGHT_WIDTH = 8, // Width of the data stored in BRAM
    parameter BRAM_DEPTH = 28*28 // Depth of the BRAM
) (
    input clk,
    input wr_en, // Write enable signal
    input [BRAM_ADDR_WIDTH-1:0] wr_addr, // Address to write to BRAM
    input [WEIGHT_WIDTH-1:0] data_in, // Data to write to BRAM
    input [BRAM_ADDR_WIDTH-1:0] rd_addr, // Address to read from BRAM
    output [WEIGHT_WIDTH-1:0] data_out // Data read from BRAM
);

reg [7:0] bram [BRAM_DEPTH-1:0]; // BRAM memory array


always @(posedge clk) begin
    if (wr_en) begin
        bram[wr_addr] <= data_in; // Write data to BRAM
    end
end
assign data_out = bram[rd_addr]; // Read data from BRAM

endmodule