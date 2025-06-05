module convolve (
    input i_clk,
    input i_rst,
    input i_start,
    input [7:0] i_src1_data1,
    input [7:0] i_src1_data2,
    input [9:0] i_src1_start_addr,
    input [9:0] i_kernal_start_addr,
    input [9:0] dest_address1,
    input [9:0] dest_address2,
    input [2:0] i_stride,
    output reg [7:0] o_sum1,
    output reg [7:0] o_sum2,
    output reg o_done,
    output reg [9:0] src1_addr2,
    output [9:0] src1_src2_addr1
);

reg [7:0] kernal [2:0][2:0];
reg [9:0] i,j;
reg [3:0] i_k, j_k;

parameter IDLE = 3'b000, READ_KERNEL = 3'b001, LOAD_WINDOWS = 3'b010, CALC = 3'b011,WRITE = 3'b100;
reg addr_switch;
reg [2:0] state, next_state;
reg [7:0] window1 [2:0][2:0]; // Shared buffer for 3x3 window
reg [7:0] window2 [2:0][2:0]; // Shared buffer for 3x3 window
reg [9:0] kernal_addr,src1_addr1;
assign src1_src2_addr1 = (addr_switch) ? kernal_addr : src1_addr1;
always @(posedge i_clk or posedge i_rst) begin
    if (i_rst)
        state <= IDLE;
   
    else
        state <= next_state;
end
always @(*) begin
case(state)
    IDLE: begin
        if (i_start) begin
            next_state <= READ_KERNEL;

        end else begin
            next_state <= IDLE;
    
        end
    end
    READ_KERNEL: begin
        if(i_k == 2 && j_k == 2) begin
            next_state <= LOAD_WINDOWS;
            end
        else begin
            next_state <= READ_KERNEL;
        end
    end
    LOAD_WINDOWS: begin
 if(i == 3 - 1 && j == 3 - 1) begin
                next_state <= CALC;
            end else begin
                next_state <= LOAD_WINDOWS;
            end
    end
    CALC: begin
        if(i_k == 2 && j_k == 2) begin
            next_state <= WRITE;
        end else begin
            next_state <= CALC;
        end
    end
    WRITE: begin
        next_state <= IDLE;
    end
    default: next_state <= IDLE;
    endcase
end
always @(posedge i_clk ) begin

     case(state) 
        IDLE: begin
        i <= 0;
        j <= 0;
        j_k <= 0;
        i_k <= 0;
        o_sum1 <= 0;
        o_sum2 <= 0;
        o_done <= 0;
        addr_switch <= 0;
        kernal_addr <= i_kernal_start_addr;
        src1_addr1 <= i_src1_start_addr;
        src1_addr2 <= i_src1_start_addr + i_stride;
        
            end
        READ_KERNEL: begin
            addr_switch <= 1;
            kernal_addr <= kernal_addr + 1;
        kernal[i_k][j_k] <= i_src1_data1;
            if( (i_k == 2) && (j_k == 2)) begin
             i_k <= 0;
             j_k <= 0;
             addr_switch <= 0;
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
                    i <= 0;
                end
                else begin
                    src1_addr1 <= src1_addr1 + 28 - j;
                    src1_addr2 <= src1_addr1 + 28 - j + i_stride;
                    i <= i + 1;
                end
            end
            else begin
                src1_addr1 <= src1_addr1 + 1;
                j <= j + 1;
            end
        end
        CALC: begin

                    o_sum1 <= o_sum1 + (window1[i_k][j_k] * kernal[i_k][j_k]);
                    o_sum2 <= o_sum2 + (window2[i_k][j_k] * kernal[i_k][j_k]);
            if( (i_k == 2) && (j_k == 2)) begin
                j_k <= 0;
                i_k <= 0;
                o_done <= 1;
            end else if (i_k == 2) begin
                j_k <= j_k + 1;
                i_k <= 0;
            end else begin
                i_k <= i_k + 1;
            end
        end
        endcase
end

endmodule