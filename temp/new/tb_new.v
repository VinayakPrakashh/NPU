`timescale 1ns/1ps

module tb_tope();
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
    
    // Monitoring signals
    wire [BIT_DEPTH-1:0] in_l1, in_l2, in_l3;
    
    // Instantiate the DUT (Device Under Test)
    top #(
        .BIT_DEPTH(BIT_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stride(stride),
        .shift_buffer(shift_buffer),
        .done(done)
    );
    
    // Connect internal signals for monitoring (if needed)
    assign in_l1 = dut.in_l1;
    assign in_l2 = dut.in_l2;
    assign in_l3 = dut.in_l3;
    
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
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD*2);
        
        // Display initial buffer contents
        $display("Initial buffer state:");
        $display("in_l1 = %d, in_l2 = %d, in_l3 = %d", in_l1, in_l2, in_l3);
        
        // Start with stride 1
        $display("=== Testing with stride = 1 ===");
        stride = 1;
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for completion or timeout
        wait(done || $time > 1000);
        
        if (done) 
            $display("Convolution with stride 1 completed successfully!");
        else 
            $display("Timeout waiting for done signal with stride 1");
            
        #(CLK_PERIOD*5);
        
        // Reset for next test
        rst = 1;
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD*2);
        
        // Test with stride 2
        $display("=== Testing with stride = 2 ===");
        stride = 2;
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for completion or timeout
        wait(done || $time > 1000);
        
        if (done) 
            $display("Convolution with stride 2 completed successfully!");
        else 
            $display("Timeout waiting for done signal with stride 2");
            
        #(CLK_PERIOD*5);
        
        $display("Testbench completed");
        $finish;
    end
    
    // Monitor important signals
    initial begin
        $monitor("Time=%0t, rst=%b, start=%b, stride=%d, shift=%b, done=%b, in_l1=%d, in_l2=%d, in_l3=%d",
                $time, rst, start, stride, shift_buffer, done, in_l1, in_l2, in_l3);
    end
    
    // Optional: Save waveforms
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_tope);
    end

endmodule