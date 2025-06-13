module linebuffer #(
    parameter BIT_DEPTH = 8, // Width of the data stored in LineBuffer
    parameter COLS = 28 // Number of columns in the LineBuffer
) (
    input clk,
    input wr_en, // Write enable signal
    input shift, // Shift enable signal
    input [BIT_DEPTH-1:0] data_in_r1, // Data to write to LineBuffer row 1
    input [BIT_DEPTH-1:0] data_in_r2, // Data to write to LineBuffer row 2
    input [BIT_DEPTH-1:0] data_in_r3, // Data to write to LineBuffer row 3
    output [BIT_DEPTH-1:0] rd_data_r1, // Data read from LineBuffer row 1
    output [BIT_DEPTH-1:0] rd_data_r2, // Data read from LineBuffer row 2
    output [BIT_DEPTH-1:0] rd_data_r3 // Data read from LineBuffer row 3
);
integer i;
reg [7:0] buffer_row1 [0:COLS-1]; // LineBuffer memory array for row 1
reg [7:0] buffer_row2 [0:COLS-1]; // LineBuffer memory array for row 2
reg [7:0] buffer_row3 [0:COLS-1]; // LineBuffer memory array for row 3
always @(posedge clk) begin
    if (wr_en || shift) begin
        buffer_row1[0] <= data_in_r1; // Write data to LineBuffer row 1
        buffer_row2[0] <= data_in_r2; // Write data to LineBuffer row 2
        buffer_row3[0] <= data_in_r3; // Write data to LineBuffer row 3

        for (i = 0; i < COLS-1; i = i + 1) begin
            buffer_row1[i+1] <= buffer_row1[i];
            buffer_row2[i+1] <= buffer_row2[i];
            buffer_row3[i+1] <= buffer_row3[i];
				end
        end
end
assign rd_data_r1 = buffer_row1[COLS-1]; // Read data from LineBuffer row 1
assign rd_data_r2 = buffer_row2[COLS-1]; // Read data from LineBuffer row 2
assign rd_data_r3 = buffer_row3[COLS-1]; // Read data from LineBuffer row 3
initial begin
    for (i = 0; i < COLS; i = i + 1) begin
        buffer_row1[i] = (i % 5) + 1; // Values 1,2,3,4,5,1,2,3,4,5,...
        buffer_row2[i] = ((i+1) % 5) + 1; // Values 2,3,4,5,1,2,3,4,5,1,...
        buffer_row3[i] = ((i+2) % 5) + 1; // Values 3,4,5,1,2,3,4,5,1,2,...
    end
end

endmodule