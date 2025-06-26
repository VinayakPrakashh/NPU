module Load_buffer #(
    parameter BIT_DEPTH = 8,
    parameter BUFFER_SIZE = 28
) (
    input clk,
    input rst,
    input start,
    input shift_en,
    input row_num,
    input [BIT_DEPTH-1:0] din1,
    input [BIT_DEPTH-1:0] din2,
    input [BIT_DEPTH-1:0] din3,
    output reg [BIT_DEPTH-1:0] dout1,
    output reg [BIT_DEPTH-1:0] dout2,
    output reg [BIT_DEPTH-1:0] dout3
    output reg done
);

reg [3:0] state, next_state;
reg [9:0] addr1,addr2,addr3;


parameter IDLE = 4'b0000,
          LOAD = 4'b0001,
          SHIFT = 4'b0010,
          DONE = 4'b0011;

always @(posedge clk ) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if (start) begin
                next_state = LOAD;
            end else begin
                next_state = IDLE;
            end
        end
        
        LOAD: begin
            is 
        end
        
        DONE: begin
            next_state = IDLE;
        end
        
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    case(state)
        IDLE: begin
            dout1 <= 0;
            dout2 <= 0;
            dout3 <= 0;
            done <= 0;
            addr1 <= ( row_num << 5 ) - ( row_num << 2 )
            addr2 <= ( row_num << 5 ) - ( row_num << 2 ) + BUFFER_SIZE;
            addr3 <= ( row_num << 5 ) - ( row_num << 2 ) + (BUFFER_SIZE * 2);


        end

        LOAD: begin
            shift_en <= 1;
            addr1 <= addr1 + 1;
            addr2 <= addr2 + 1; 
            addr3 <= addr3 + 1;
        end

        SHIFT: begin
            dout1 <= {dout1[BIT_DEPTH-2:0], din1};
            dout2 <= {dout2[BIT_DEPTH-2:0], din2};
            dout3 <= {dout3[BIT_DEPTH-2:0], din3};
        end

        DONE: begin
            done <= 1;
        end

        default: begin
            dout1 <= 0;
            dout2 <= 0;
            dout3 <= 0;
        end
    endcase
end


endmodule