module bram #(
    BIT_DEPTH = 8, // Width of the data stored in BRAM
    ADDR_WIDTH = 10, // Address width for BRAM
    DEPTH = 784 // Depth of the BRAM
) (
    input clk,
    input wr_en, // Write enable signal
    input rd_en, // Read enable signal
    input [ADDR_WIDTH-1:0] wr_addr, // Address to write to BRAM
    input [BIT_DEPTH-1:0] data_in, // Data to write to BRAM
    input [ADDR_WIDTH-1:0] rd_addr, // Address to read from BRAM
    output reg [BIT_DEPTH-1:0] data_out // Data read from BRAM
);

reg [BIT_DEPTH-1:0] bram [DEPTH-1:0]; // BRAM memory array

always @(posedge clk) begin
    if (wr_en) begin
        bram[wr_addr] <= data_in; // Write data to BRAM
    end
    if (rd_en) begin
        data_out <= bram[rd_addr]; // Read data from BRAM
    end
end

endmodule