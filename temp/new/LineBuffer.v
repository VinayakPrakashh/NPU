module LineBuffer #(
    parameter BIT_DEPTH = 8, // Width of the data stored in LineBuffer
) (
    input clk,
    input wr_en, // Write enable signal
    input shift, // Shift enable signal
    input [BIT_DEPTH-1:0] data_in_r1, // Data to write to LineBuffer
    input [BIT_DEPTH-1:0] data_in_r2, // Data to write to LineBuffer
    input [BIT_DEPTH-1:0] data_in_r3, // Data to write to LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r1, // to read from LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r2, // to read from LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r3, // to read from LineBuffer
);
reg [BIT_DEPTH-1:0] buffer_row1 [2:0]; // LineBuffer memory array
reg [BIT_DEPTH-1:0] buffer_row2 [2:0]; // LineBuffer memory array
reg [BIT_DEPTH-1:0] buffer_row3 [2:0]; // LineBuffer memory array

always @(posedge clk) begin
    if (wr_en && ~shift) begin
        buffer_row1[0] <= data_in_r1; // Write data to LineBuffer row 1
        buffer_row2[0] <= data_in_r2; // Write data to LineBuffer row 2
        buffer_row3[0] <= data_in_r3; // Write data to LineBuffer row 3
    end
    // Shift the rows to the left
    if(shift && ~wr_en) begin
        buffer_row1[1] <= buffer_row1[0];
        buffer_row1[2] <= buffer_row1[1];
        buffer_row2[1] <= buffer_row2[0];
        buffer_row2[2] <= buffer_row2[1];
        buffer_row3[1] <= buffer_row3[0];
        buffer_row3[2] <= buffer_row3[1];
    end
end
assign rd_data_r1 = buffer_row1[2]; // Read data from LineBuffer row 1
assign rd_data_r2 = buffer_row2[2]; // Read data from LineBuffer row 2
assign rd_data_r3 = buffer_row3[2]; // Read data from LineBuffer row 3
endmodule