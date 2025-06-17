module kernel_reg #(
    parameter BIT_DEPTH = 8, // Width of the data stored in kernel_reg
    parameter KERNEL_SIZE = 3 // Size of the kernel (3x3)
) (
    input clk,
    input [7:0] kernel_in,
    input wr_en, // Write enable signal
    input rol, // Shift enable signal
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    output reg [7:0] out1,
    output reg [7:0] out2,
    output reg [7:0] out3,
);

reg [7:0] kernel_buffer [0:KERNEL_SIZE*KERNEL_SIZE-1]; // Kernel memory array

wire [7:0] in;
always @(posedge clk ) begin
    if(wr_en || shift) begin
    kernel_buffer[0] <= kernel_in;
    for (i = 0; i < 9; i++) begin
        kernel_buffer[i] <= kernel_buffer[i-1];
end

    end
end

assign in = (rol) ? kernel[
    
]


endmodule