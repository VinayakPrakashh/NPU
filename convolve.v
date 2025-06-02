module convolve (
    input i_clk,
    input i_rst,
    input i_start,
    input [7:0] i_src1_data,
    input [7:0] i_kernal_data,
    input i_src1_start_addr,
    input i_kernal_start_addr,
    input [2:0] stride,
);

reg [7:0] kernel [3:0][3:0];
reg [9:0] i,j;
reg [3:0] i_k, j_k;
reg [7:0] sum1,sum2;

parameter IDLE = 3'b000, READ_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, WRITE = 3'b011;

reg [2:0] state, next_state;
reg [7:0] window1 [2:0][2:0]; // Shared buffer for 3x4 window
reg [7:0] window2 [2:0][2:0]; // Shared buffer for 3x5 window
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
            end
        READ_KERNEL: begin
            i_kernal_start_addr <= i_kernal_start_addr + 1;
            kernel[i_k][j_k] <= i_kernal_data;
            if( (i_k == 3) && (j_k == 3)) begin
                next_state <= CALC;
            end else if (i_k == 3) begin
                j_k <= j_k + 1;
                i_k <= 0;
            end else begin
                i_k <= i_k + 1;
            end
        end
        // LOAD_WINDOWS: begin
        //         if (stride == 1) begin
        //         shared_buffer1[i][j] <= i_src1_data;
        //     end else if (stride == 2) begin
        //         shared_buffer2[i][j] <= i_src1_data;
        //     end
        //     if(j == 3 - 1 + stride) begin
        //         j <= 0;
        //         if(i == 3-1) begin
        //             next_state <= CALC;
        //             i <= 0;
        //         end
        //         else begin
        //             i_src1_start_addr <= i_src1_start_addr + 28 - j;
        //             i <= i + 1;
        //         end
        //     end
        //     else begin
        //         i_src1_start_addr <= i_src1_start_addr + 1;
        //         j <= j + 1;
        //     end
        // end
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
                    i_src1_start_addr <= i_src1_start_addr + 28 - j;
                    src1_addr2 <= i_src1_start_addr + 28 - j+ stride;
                    i <= i + 1;
                end
            end
            else begin
                i_src1_start_addr <= i_src1_start_addr + 1;
                j <= j + 1;
            end
        end
        CALC: begin 
            sum1 <= sum1 + (shared_buffer1[i][j] * kernel[i][j]);
            if(stride == 1) begin
            sum2 <= sum2 + (shared_buffer1[i+1][j] * kernel[i][j]);
            end
            else if(stride == 2) begin
            sum2 <= sum2 + (shared_buffer2[i+2][j] * kernel[i][j]);
            end
            if(j == 3 - 1) begin
                j = 0;
                if(i == 3 - 1) begin
                    i = 0;
                end
                else begin
                    i = i + 1;
                end
            end
            else begin 
                j<= j + 1;

            end
        end
        endcase
end

endmodule