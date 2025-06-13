`timescale 1ns / 1ps

module tb_convolve();
    // Parameters
    parameter BIT_DEPTH = 8;
    parameter CLK_PERIOD = 10; // 10ns (100MHz) clock

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [1:0] stride;
    reg [7:0] in_l1;
    reg [7:0] in_l2;
    reg [7:0] in_l3;
    
    // Outputs
    wire shift_buffer;
    wire done;
    
    // Internal monitoring signals
    wire window_en;
    wire [3:0] counter;
    wire [2:0] state;
    
    // Instantiate the Device Under Test (DUT)
    convolve #(
        .BIT_DEPTH(BIT_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .stride(stride),
        .in_l1(in_l1),
        .in_l2(in_l2),
        .in_l3(in_l3),
        .shift_buffer(shift_buffer),
        .done(done)
    );
    
    // Access internal signals for monitoring (adjust if needed)
    assign window_en = dut.window_en;
    assign counter = dut.counter;
    assign state = dut.state;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;
        stride = 2; // Start with stride 1
        in_l1 = 0;
        in_l2 = 0;
        in_l3 = 0;
        
        // Apply reset
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD);
        
        // Test Case 1: Stride = 1
        $display("Testing with stride = 1");
        stride = 2;
        
        // Feed sample data
        in_l1 = 8'd10; // Example values
        in_l2 = 8'd20;
        in_l3 = 8'd30;
        
        // Start convolution
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for LOAD phase and feed new data each cycle
        repeat(8) begin
            #(CLK_PERIOD);
            // Update input data for demonstration
            in_l1 = in_l1 + 1;
            in_l2 = in_l2 + 1;
            in_l3 = in_l3 + 1;
        end
        
        // Wait for done
        wait(done);
        #(CLK_PERIOD*2);
        
        // Test Case 2: Stride = 2
        $display("Testing with stride = 2");
        rst = 1;
        #(CLK_PERIOD*2);
        rst = 0;
        #(CLK_PERIOD);
        
        stride = 2;
        
        // Reset data values
        in_l1 = 8'd50;
        in_l2 = 8'd60;
        in_l3 = 8'd70;
        
        // Start second convolution
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for LOAD phase and feed new data each cycle
        repeat(10) begin
            #(CLK_PERIOD);
            // Update input data
            in_l1 = in_l1 + 1;
            in_l2 = in_l2 + 1;
            in_l3 = in_l3 + 1;
        end
        
        // Wait for done
        wait(done);
        #(CLK_PERIOD*2);
        
        $display("Testbench completed successfully!");
  
        $finish;
    end
    
    // Monitor state changes and key signals
    initial begin
        $monitor("Time=%0t, State=%d, Start=%b, Stride=%d, Counter=%d, Window_en=%b, Shift=%b, Done=%b",
                 $time, state, start, stride, counter, window_en, shift_buffer, done);
    end
    
    // Optional: Waveform trace
    initial begin
        $dumpfile("tb_convolve.vcd");
        $dumpvars(0, tb_convolve);
    end

endmodule