module convolve (
    input i_clk,
    input i_rst,
    input i_start,
    input [7:0] i_src1_data1,
    input [7:0] i_src1_data2,
    input [7:0] i_kernal_data,
    input [9:0] i_src1_start_addr,
    input [9:0] i_kernal_start_addr,
    input [2:0] i_stride,
);

reg [7:0] kernal [2:0][2:0];
reg [9:0] i,j;
reg [3:0] i_k, j_k;
reg [7:0] sum1,sum2;

parameter IDLE = 3'b000, READ_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, CALC = 3'b011;

reg [2:0] state, next_state;
reg [7:0] window1 [2:0][2:0]; // Shared buffer for 3x3 window
reg [7:0] window2 [2:0][2:0]; // Shared buffer for 3x3 window
reg [9:0] src1_addr2,src1_addr1,kernal_addr;
always @(posedge i_clk or posedge i_rst) begin

        case(state) 
        IDLE: begin
        i <= 0;
        j <= 0;
        j_k <= 0;
        i_k <= 0;
        sum1 <= 0;
        sum2 <= 0;
        src1_addr2 <= i_src1_start_addr + stride;
        src1_addr1 <= i_src1_start_addr;
        kernal_addr <= i_kernal_start_addr;
        
            end
        READ_KERNEL: begin
            kernal_addr <= kernal_addr + 1;
        kernal[i_k][j_k] <= i_kernal_data;
            if( (i_k == 2) && (j_k == 2)) begin
                next_state <= LOAD_WINDOWS;
            end else if (i_k == 2) begin
                j_k <= j_k + 1;
                i_k <= 0;
            end else begin
                i_k <= i_k + 1;
            end
        end

        LOAD_WINDOWS: begin
                window1[i][j] <= i_src1_data1;
                window2[i][j] <= i_src1_data2;

                 if(j == 3 - 1) begin
                j <= 0;
                if(i == 3-1) begin
                    next_state <= CALC;
                    i <= 0;
                end
                else begin
                    src1_addr1 <= src1_addr1 + 28 - j;
                    src1_addr2 <= src1_addr1 + 28 - j + stride;
                    i <= i + 1;
                end
            end
            else begin
                src1_addr1 <= src1_addr1 + 1;
                j <= j + 1;
            end
        end
        CALC: begin

                    sum1 <= sum1 + (window1[i_k][j_k] * kernal[i_k][j_k]);
                    sum2 <= sum2 + (window2[i_k][j_k] * kernal[i_k][j_k]);
            if( (i_k == 2) && (j_k == 2)) begin
                next_state <= LOAD_WINDOWS;
            end else if (i_k == 2) begin
                j_k <= j_k + 1;
                i_k <= 0;
            end else begin
                i_k <= i_k + 1;
            end
            end
            // Output the result or store it in a register
            next_state <= IDLE; // Go back to IDLE after calculation


        endcase
end

endmodule