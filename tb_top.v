`timescale 1ns/1ps

module tb_npt_top;

    reg i_clk;
    reg i_rst;
    reg i_start;
    wire o_done;

    // Instantiate the DUT (Device Under Test)
    npt_top uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_start(i_start),
        .o_done(o_done)
    );

    // Clock generation: 10ns period
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    // Stimulus
    initial begin
        i_rst = 1;
        i_start = 0;
        #20;
        i_rst = 0;
        #20;
        i_start = 1;
        #10;
        i_start = 0;

        // Wait for done
        wait(o_done);
        #20;

        $display("Convolution done!");
        $finish;
    end

endmodule