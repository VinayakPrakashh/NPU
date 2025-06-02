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
reg [9:0] i;
reg [3:0] i_k, j_k;
reg [7:0] sum;

parameter IDLE = 3'b000, READ_KERNEL = 3'b001, CALC = 3'b010, WRITE = 3'b011;

reg [2:0] state, next_state;
reg done;

always @(posedge i_clk or posedge i_rst) begin

        case(state) 
        IDLE: begin
        i <= 0;
        j_k <= 0;
        i_k <= 0;
        sum <= 0;
        done <= 0;
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
        CALC: begin
            sum <= sum + (i_src1_data * kernel[i_k][j_k]);
            end
        endcase
end

endmodule