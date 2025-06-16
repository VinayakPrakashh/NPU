module max_pool(
  input clk,pool_en,rst
  input [7:0] data_in,
  output [7:0]rd_data
)
reg [7:0] d1,d2,d3,d4;
reg [7:0] buffer [51:0];
reg [1:0] state,next_state;
reg [6:0] counter,pool_idx;
parameter IDLE=2'b00,WRITE=2'b01,LOAD=2'b10,POOL=2'b11;
always @(posedge clk or posedge rst)begin
 if(rst)begin
    state<=IDLE;
 end else begin
    state<=next_state;
 end
end
always @(*)begin
   case(state)
      IDLE:begin
        next_state=WRITE;
end
    WRITE:begin
    if(counter==7'd51)
        next_state=POOL;
    else 
      next_state=WRITE;
    end
    LOAD:begin
      next_state=POOL;
    end
    POOL:begin
        if(counter<7'd24)
          next_state=LOAD;
        else
          next_state=IDLE;
    end
   endcase

end
always @(posedge clk)begin
 case(state)
  IDLE:begin
    counter<=7'b0;
    counter1<=7'b1;
    rd_data<=8'b0;
  end
   WRITE:begin
      buffer[counter]<=data_in;
      counter<=counter+1'b1;
      if(counter==7'd51)begin
        counter<=6'b0;
      end
   end
   LOAD:begin
      d1<=buffer[counter];
      d2<=buffer[counter+1];
      d3<=buffer[pool_idx];
      d4<=buffer[pool_idx+1];
   end
   POOL:begin
     rd_data <= 
    (d1 >= d2 && d1 >= d3 && d1 >= d4) ? d1 :
    (d2 >= d3 && d2 >= d4)             ? d2 :
    (d3 >= d4)                         ? d3 : d4;
    counter<=counter+1'b1;
    pool_idx<=pool_idx+1'b1;
   end
 endcase
end
endmodule