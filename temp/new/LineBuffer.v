module LineBuffer #(
    parameter BIT_DEPTH = 8, // Width of the data stored in LineBuffer
    parameter ROWS = 3,      // Number of rows in the LineBuffer
    parameter COLS = 28      // Number of columns in the LineBuffer
) (
    input clk,
    input wr_en,            // Write enable signal
    input shift,            // Shift enable signal
    input [BIT_DEPTH-1:0] data_in_r1, // Data to write to LineBuffer
    input [BIT_DEPTH-1:0] data_in_r2, // Data to write to LineBuffer
    input [BIT_DEPTH-1:0] data_in_r3, // Data to write to LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r1, // to read from LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r2, // to read from LineBuffer
    output [BIT_DEPTH-1:0] rd_data_r3  // to read from LineBuffer
);
    reg [BIT_DEPTH-1:0] buffer_row1 [0:COLS-1]; // LineBuffer memory array
    reg [BIT_DEPTH-1:0] buffer_row2 [0:COLS-1]; // LineBuffer memory array
    reg [BIT_DEPTH-1:0] buffer_row3 [0:COLS-1]; // LineBuffer memory array
    
    integer i;
    
    always @(posedge clk) begin
        if (wr_en || shift) begin
            // Insert new data at position 0
            buffer_row1[0] <= data_in_r1; // Write data to LineBuffer row 1
            buffer_row2[0] <= data_in_r2; // Write data to LineBuffer row 2
            buffer_row3[0] <= data_in_r3; // Write data to LineBuffer row 3
            
            // Shift all elements to the right in parallel
            for (i = 0; i < COLS-1; i = i + 1) begin
                buffer_row1[i+1] <= buffer_row1[i];
                buffer_row2[i+1] <= buffer_row2[i];
                buffer_row3[i+1] <= buffer_row3[i];
            end
        end
    end
    
    // Read output from a specific column (column 2 in this example)
    assign rd_data_r1 = buffer_row1[27]; // Read data from LineBuffer row 1
    assign rd_data_r2 = buffer_row2[27]; // Read data from LineBuffer row 2
    assign rd_data_r3 = buffer_row3[27]; // Read data from LineBuffer row 3
    
initial begin
    // Fill all rows with sequential values from 0 to 27
    for (i = 0; i < COLS; i = i + 1) begin
        buffer_row1[i] = i;        // Row 1: 0,1,2,3,...,27
        buffer_row2[i] = i;        // Row 2: 0,1,2,3,...,27
        buffer_row3[i] = i;        // Row 3: 0,1,2,3,...,27
    end
end
endmodule