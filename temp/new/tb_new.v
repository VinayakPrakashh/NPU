`timescale 1ns/1ps

module tb_top();
    // Parameters
    parameter BIT_DEPTH = 8;
    parameter CLK_PERIOD = 10; // 10ns (100MHz) clock
    
    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [1:0] stride;
    
    // Outputs
    wire shift_buffer;
    wire done;
    wire [BIT_DEPTH-1:0] sum1;
    wire [BIT_DEPTH-1:0] sum2;
    
    // Internal monitoring signals
    wire [BIT_DEPTH-1:0] in_l1, in_l2, in_l3;
    wire [BIT_DEPTH-1:0] kernel_data;
    wire [3:0] kernel_addr;
    
    // Instantiate the DUT (Device Under Test)
    top #(
        .BIT_DEPTH(BIT_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stride(stride),
        .shift_buffer(shift_buffer),
        .done(done),
        .sum1(sum1),
        .sum2(sum2)
    );
    
    // Connect internal signals for monitoring
    assign in_l1 = dut.in_l1;
    assign in_l2 = dut.in_l2;
    assign in_l3 = dut.in_l3;
    assign kernel_data = dut.kernel_data;
    assign kernel_addr = dut.kernel_addr;
    
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
        stride = 1;
        
        // Apply reset
        #(CLK_PERIOD*3);
        rst = 0;
        #(CLK_PERIOD*2);
        
        // Display initial state
        $display("=== Initial State ===");
        $display("Time=%0t: in_l1=%d, in_l2=%d, in_l3=%d", $time, in_l1, in_l2, in_l3);
        $display("Time=%0t: kernel_data=%d, kernel_addr=%d", $time, kernel_data, kernel_addr);
        
        // Test with Stride = 1
        $display("=== Starting Convolution with stride = 1 ===");
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Monitor convolution process
        while (!done && $time < 2000) begin
            #(CLK_PERIOD);
            if (shift_buffer) 
                $display("Time=%0t: Shifting - in_l1=%d, in_l2=%d, in_l3=%d, kernel_addr=%d", 
                        $time, in_l1, in_l2, in_l3, kernel_addr);
        end
        
        if (done) begin
            $display("=== Convolution Completed Successfully! ===");
            $display("Final Results: sum1=%d, sum2=%d", sum1, sum2);
        end else begin
            $display("ERROR: Timeout waiting for done signal");
        end
        
        #(CLK_PERIOD*10);
        
        $display("=== Testbench Completed ===");
        $finish;
    end
    
    // Monitor key signals continuously
    initial begin
        $monitor("Time=%0t | rst=%b start=%b stride=%d | shift=%b done=%b | sum1=%d sum2=%d",
                $time, rst, start, stride, shift_buffer, done, sum1, sum2);
    end
    
    // Optional: Save waveforms for debugging
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
    end

endmodule