`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// 
// Create Date: 06/05/2025
// Module Name: load
//////////////////////////////////////////////////////////////////////////////////

module load(
    input clk,
    input rst,
    input [1:0] stride,
 
);
    // Memory declaration
    reg [7:0] ram[17:0];  // 18 elements
    parameter num_columns=2;
    reg [2:0] element_count;
    // Read pointers and window
    reg [4:0] rdptr1;
    reg [4:0] rdptr2;
    reg [1:0] j;
    reg [7:0] window1[8:0];
    reg [7:0] window2[8:0];
    reg [3:0] wrptr1;
    // RAM initialization
    integer i;
    initial begin
        for (i = 0; i < 18; i = i + 1) begin
            ram[i] = i + 1; // values from 1 to 18
        end
    end

    // Update rdptr2 based on stride
    always @(posedge clk) begin
        case (stride)
            2'b01: rdptr2 <= rdptr1 + 1;
            2'b10: rdptr2 <= rdptr1 + 2;
            2'b11: rdptr2 <= rdptr1 + 3;
            default: rdptr2 <= rdptr1;
        endcase
    end

    // Increment rdptr1 unless reset
    always @(posedge clk) begin
        if (rst)begin
            rdptr1 <= 5'd0;
            wrptr1<=4'b0;
            j<=2'b0;
        end 
        else
            rdptr1 <= rdptr1 + 1;
    end

    // Read from RAM and assign to outputs
    always @(posedge clk) begin
    ram[rdptr1]<=window1[wrptr1];
    ram[rdptr2]<=window2[wrptr1];
    if(rdptr2%5==0)begin
        j<=j+1'b1;
        rdptr1<=3'd6+j;
    end
    if(wrptr1==4'd9)
      wrptr<=4'd0;
end
endmodule
ithaan logic udeshichath updated test cheythittilla