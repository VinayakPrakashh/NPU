module bram0 #(
    parameter BRAM_ADDR_WIDTH = 10, // Address width for BRAM
    parameter WEIGHT_WIDTH = 8, // Width of the data stored in BRAM
    parameter BRAM_DEPTH = 28*28// Depth of the BRAM
) (
    input i_clk,
    input wr_en,
    input [BRAM_ADDR_WIDTH-1:0] wr_addr, // Address to write to BRAM
    input [WEIGHT_WIDTH-1:0] wr_data, // Data to write to BRAM
    input [BRAM_ADDR_WIDTH-1:0] rd_addr, // Address to read from BRAM
    output [WEIGHT_WIDTH-1:0] rd_data // Data read from BRAM
);

reg [WEIGHT_WIDTH-1:0] bram [0:BRAM_DEPTH-1]; // BRAM memory array

always @(posedge i_clk) begin
    if (wr_en) begin
        bram[wr_addr] <= wr_data; // Write data to BRAM
    end
end
assign rd_data = bram[rd_addr]; // Read data from BRAM   
integer i;
initial begin
    for (i = 0; i < 100; i = i + 1) begin
        bram[i] = (i % 5) + 1;  // Cycles through 1, 2, 3, 4, 5
    end
    for (i = 100; i < BRAM_DEPTH; i = i + 1) begin
        bram[i] = 0;  // Zero out the rest
    end
    end
endmodule