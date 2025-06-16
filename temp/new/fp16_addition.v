module floatadd #(
    parameters
) (
    input [15:0] a, // 16-bit floating point input a
    input [15:0] b, // 16-bit floating point input b
    output [15:0] result // 16-bit floating point output result
);

reg sign;
reg signed [5:0] exponent;
reg [9:0] mantissa;
reg [4:0] exponent_a, exponent_b;
reg [10:0] fraction_a, fraction_b,fraction; //1.M form
reg [7:0] shift; // Shift amount for alignment
always @(a or b ) begin
exponent_a = a[14:10]; // Extract exponent of a
exponent_b = b[14:10]; // Extract exponent of b
fraction_a = {1'b1, a[9:0]}; // Extract mantissa of a (with implicit leading 1)
fraction_b = {1'b1, b[9:0]}; // Extract mantissa of b (with implicit leading 1)


if(a == 0) begin
    result = b;
end
else if(b == 0) begin
    result = a;
end else if( (a[14:0] == b[14:0]) && (a[15] ^ b[15] == 1'b1))begin
    result = 0; // If both numbers are equal and have different signs, result is zero
end
else begin
    if(exponent_b > exponent_a) begin
        shift = exponent_b - exponent_a; // Calculate shift amount
        fraction_a = fraction_a >> shift; // Align fraction_a to fraction_b
        exponent = exponent_b; // Use exponent of b
    end
    else if(exponent_a > exponent_b) begin
        shift = exponent_a - exponent_b; // Calculate shift amount
        fraction_b = fraction_b >> shift; // Align fraction_b to fraction_a
        exponent = exponent_a; // Use exponent of a
    end else begin
        if(a[15] == b[15]) begin
            {cout,fraction} = fraction_a + fraction_b; // Add fractions if signs are the same
            if(cout == 1) begin
                exponent = exponent_a + 1; // Increment exponent if overflow occurs
                fraction = fraction >> 1; // Adjust fraction for normalization
            end 
            sign = a[15]; // Set sign bit
        end
        else begin
            if(a[15] == 1'b1) begin
                {cout,fraction} = fraction_b - fraction_a; // Subtract fractions if a is negative
            end
            else begin
                {cout,fraction} = fraction_a - fraction_b; // Subtract fractions if b is negative
            end
        end
        sign  = cout;
        if(cout == 1'b1) begin
            fraction = -fraction; // Adjust fraction for negative result
        end
        
        end
        end   
end

endmodule