`timescale 1ns / 1ps

module tb_npt_top;

    // Inputs to npt_top
    reg i_clk;
    reg i_rst;
    reg i_start;
    wire [2:0] state;
    wire [5:0] kernal_reg_wr_address; // Expose kernel register write address for monitoring

    // Output from npt_top
    wire o_done;
    // Connect to top
    npt_top uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_start(i_start),
        .o_done(o_done),
        .state(state),
        .kernal_reg_wr_address(kernal_reg_wr_address)   
    );
    // Clock Generation: 100 MHz
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end
    initial begin
        $monitor("Time: %0t, i_clk: %b, i_rst: %b, i_start: %b, o_done: %b", $time, i_clk, i_rst, i_start, o_done);
        i_rst = 1;
        i_start = 0;

        #20;
        i_rst = 0;

        // Start kernel loading
        #20;
        i_start = 1;
        #10;
        i_start = 0;

        // Wait until done
        wait(o_done == 1);
        $display("Kernel loading done at time %0t", $time);
      

        #20;
        $stop;
    end

endmodule
