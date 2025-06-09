module Buffer #(
    parameter COLS = 6;
    parameter ROWS = 3;
    parameter WIDTH = 8;
)(
    input i_clk,
    input i_rst,
    input i_wr_en,
    input i_rd_en,
    input [7:0] i_data,
    output reg [24:0] o_data
);

reg [7:0] buffer [ROWS*COLS-1:0]; // 512 elements of 8 bits each
reg [5:0] wrptr;
reg [5:0] rdptr;

always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        wrptr <= 0;

    end else begin
        if(i_wr_en) begin
            buffer[wrptr] <= i_data; // Write data to the buffer
            wrptr <= (wrptr + 1);
        end
    end
    end
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst) begin
        rdptr <= 0;
    end else begin
        if (i_rd_en) begin
          rdptr <= rdptr + 1;
        end
    end
    end

o_data <= {buffer[rdptr], buffer[rdptr+1], buffer[rdptr+2]};
  
always @(posedge i_clk) begin
    
end
endmodule