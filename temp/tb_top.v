`timescale 1ns / 1ps

module tb_top;

// Parameters
parameter BIT_DEPTH = 8;
parameter CLK_PERIOD = 10; // 10ns clock period (100MHz)

// Testbench signals
reg clk;
reg rst;
reg start;
reg pool_type;
reg pool_en;
reg [1:0] stride;

// Outputs from DUT
wire shift_buffer;
wire done;
wire [BIT_DEPTH-1:0] sum1;
wire [BIT_DEPTH-1:0] sum2;
wire [BIT_DEPTH-1:0] sum_out;
wire [4:0] out_dest_addr;
wire dest_wr_en;
wire rd_data;

// Instantiate the DUT (Device Under Test)
top #(
    .BIT_DEPTH(BIT_DEPTH)
) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .pool_type(pool_type),
    .pool_en(pool_en),
    .stride(stride),
    .shift_buffer(shift_buffer),
    .done(done),
    .sum1(sum1),
    .sum2(sum2),
    .sum_out(sum_out),
    .out_dest_addr(out_dest_addr),
    .dest_wr_en(dest_wr_en),
    .rd_data(rd_data)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize signals
    rst = 1;
    start = 0;
    pool_type = 1;  // Set pool_type to 1
    pool_en = 1;    // Set pool_en to 1
    stride = 2'b01; // Set stride to 1 only
    
    $display("=== Starting testbench with pool_type=1, pool_en=1, stride=1 ===");
    
    // Wait for a few clock cycles
    #(CLK_PERIOD * 5);
    
    // Release reset
    rst = 0;
    #(CLK_PERIOD * 2);
    
    $display("=== Test: Pooling operation with stride = 1 ===");
    start = 1;
    #(CLK_PERIOD);
    start = 0;
    
    #(CLK_PERIOD * 200);
    
    $display("=== Simulation Complete ===");
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time: %0t | rst: %b | start: %b | done: %b | sum1: %h | sum2: %h | sum_out: %h | rd_data: %b",
             $time, rst, start, done, sum1, sum2, sum_out, rd_data);
end

// Additional monitoring for key events
always @(posedge clk) begin
    if (done) begin
        $display("[%0t] Done signal asserted - Results: sum1=%h, sum2=%h, sum_out=%h, rd_data=%b", 
                 $time, sum1, sum2, sum_out, rd_data);
    end
end

// Waveform dump
initial begin
    $dumpfile("tb_top_stride1.vcd");
    $dumpvars(0, tb_top);
end

endmodule