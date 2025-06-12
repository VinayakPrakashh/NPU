`timescale 1ns/1ps

module tb_top;
    // Parameters
    parameter BIT_DEPTH = 8;
    parameter COLS = 28;
    parameter CLK_PERIOD = 10;  // 10ns (100MHz) clock period

    // Inputs
    reg clk;
    reg start;
    reg rst;
    reg [1:0] stride;
    reg wr_en;

    // Outputs
    wire done;
    
    // Internal monitoring signals
    wire shift_buffer;
    wire [BIT_DEPTH-1:0] out_l1, out_l2, out_l3;

    // Instantiate the DUT
    top #(
        .BIT_DEPTH(BIT_DEPTH),
        .COLS(COLS)
    ) dut (
        .clk(clk),
        .start(start),
        .rst(rst),
        .stride(stride),
        .wr_en(wr_en),
        .done(done)
    );

    // Connect to internal signals for monitoring
    assign shift_buffer = dut.shift_buffer;
    assign out_l1 = dut.out_l1;
    assign out_l2 = dut.out_l2;
    assign out_l3 = dut.out_l3;

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;
        stride = 1;  // Test with stride 1 first
        wr_en = 0;
        
        // Apply reset for 2 clock cycles
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD);
        
        // Start convolution with already loaded buffer
        // No need to fill buffer - initialization blocks will handle it
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for convolution to complete
        wait(done);
        #(CLK_PERIOD*2);
        
        // Test with stride 2
        rst = 1;
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD);
        
        stride = 2;
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for completion
        wait(done);
        #(CLK_PERIOD*5);
        
        $display("Testbench completed successfully!");
        $finish;
    end
    
    // Monitor important signals
    initial begin
        $monitor("Time=%0t, rst=%b, start=%b, stride=%d, shift=%b, done=%b", 
                 $time, rst, start, stride, shift_buffer, done);
    end

    // Optional: Waveform dump
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
    end

endmodule