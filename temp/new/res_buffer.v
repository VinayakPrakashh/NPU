module res_buffer1 #(
    parameter BIT_DEPTH = 8,
    parameter ADDR_WIDTH = 10
) (
    input clk,
    input [BIT_DEPTH-1:0] data_in, // Input data to be stored
    input [ADDR_WIDTH-1:0] wr_addr, // Address to write data
    input wr_en, // Write enable signal
    output reg [BIT_DEPTH-1:0] data_out // Output data from the buffer
);
reg [BIT_DEPTH-1:0] buffer [ADDR_WIDTH-1:0]; // Internal buffer to store data

always @(posedge clk) begin
    if(wr_en) begin
        buffer[wr_addr] <= data_in; // Write data to the buffer
    end

end
assign data_out = buffer[wr_addr]; // Output data from the buffer
endmodule