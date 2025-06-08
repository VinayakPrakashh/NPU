module window1_reg #(
    parameter WINDOW_ELEMNT_SIZE = 8,
    parameter WINDOW_REG_SIZE = 9, // Size of the window register
    parameter ADDR_SIZE = 4
) (
    input i_clk,
    input wr_en,
    input [ADDR_SIZE-1:0] wr_addr, // address to write to the window
    input [ADDR_SIZE-1:0] rd_addr, // address to read from the window
    input [WINDOW_ELEMNT_SIZE-1:0] wr_data, // data to write to the window
    output [WINDOW_ELEMNT_SIZE-1:0] rd_data // data read from the window
);

reg [WINDOW_ELEMNT_SIZE-1:0] window1 [WINDOW_REG_SIZE-1:0]; // Window buffer

always @(posedge i_clk ) begin
    if(wr_en) begin
        window1[wr_addr] <= wr_data; // Write data to window
    end
end

assign rd_data = window1[rd_addr]; // Read data from window


endmodule