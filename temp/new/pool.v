`timescale 1ns / 1ps
module main(
  input clk,
  input rst,
  input done,
  input [7:0] data1,
  input [7:0] data2,
  input pool_type,
  input en_comp1,
  input en_comp2,
  input pool_done,
  output  [7:0] rd_data,
  output reg [3:0] addr,
  output reg [7:0] out_data
);
 wire [7:0] out1,shifted_out,comp_out;
 comparator1 pool_1 (
    .a(data1),
    .b(data2),
    .sel(pool_type),
    .en(en_comp1),
    .out(out1)
  );
  comparator1 pool_2 (
    .a(shifted_out),
    .b(out1),
    .sel(pool_type),
    .en(en_comp2),
    .out(comp_out)
  );
siso #(
  .WIDTH(8),
  .DEPTH(13)
) siso_inst (
  .clk(clk),
  .shift_en(en_comp1),    
  .din(out1),          
  .dout(shifted_out)      
);
siso #(
  .WIDTH(8),
  .DEPTH(13)
) siso_inst1 (
  .clk(clk),
  .shift_en(shift_siso2),    
  .din(comp_out),          
  .dout(rd_data)      
);

parameter IDLE = 2'b00,
          POOL_WB = 2'b01,
          DONE = 2'b10;

reg [3:0] state, next_state;
reg [3:0] counter;
always @(posedge clk)begin
if (rst) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (state)
    IDLE: begin
      if (pool_done) begin
        next_state = POOL_WB;
      end else begin
        next_state = IDLE;
      end
    end
    POOL_WB: begin
      if (counter == 13) begin
        next_state = DONE;
      end else begin
        next_state = POOL_WB;
      end
    end
    DONE: begin
      next_state = IDLE; // Reset to IDLE after DONE
    end
    default: begin
      next_state = IDLE; // Default case to avoid latches
    end
  endcase
end
always @(posedge clk ) begin
  case (state)
    IDLE: begin
      counter <= 0; // Reset count in IDLE state
      out_wr_en <= 0; // Disable write in IDLE state
      addr <= 0; // Reset address in IDLE state
    end
    POOL_WB: begin
        counter <= counter + 1; // Increment count in POOL_WB state
        out_wr_en <= 1; // Enable write in POOL_WB state
        out_data <= rd_data; // Output data to out_data
        if(counter == 13) begin
          counter <= 0; // Reset count when it reaches 13
          out_wr_en <= 0; // Disable write when done
        end
    end
    DONE: begin
      counter <= 0; // Reset count in DONE state
      out_wr_en <= 0; // Disable write in DONE state
    end

    default: counter <= 0; // Default case to avoid latches
  endcase
end
assign shift_siso2 = out_wr_en | en_comp2; // Control signal for second SISO shift
endmodule