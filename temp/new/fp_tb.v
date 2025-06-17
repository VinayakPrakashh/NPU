`timescale 1ns / 1ps

module floatadd_tb;

  // Inputs
  reg [15:0] a;
  reg [15:0] b;

  // Output
  wire [15:0] result;

  // Expected output
  reg [15:0] expected_result;

  // Instantiate the Unit Under Test (UUT)
  floatadd uut (
    .a(a),
    .b(b),
    .result(result)
  );

  // Task to compare result
  task check_result;
    input [15:0] a_in, b_in, expected, actual;
    begin
      if (expected === actual)
        $display("PASS: a = %h, b = %h --> result = %h (expected)", a_in, b_in, actual);
      else
        $display("FAIL: a = %h, b = %h --> result = %h, expected = %h", a_in, b_in, actual, expected);
    end
  endtask

  initial begin
    // Test Case 1: 1.5 + 2.5 = 4.0
    a = 16'b0_01111_1000000000;        // 1.5
    b = 16'b0_10000_0100000000;        // 2.5
    expected_result = 16'b0_10001_0000000000; // 4.0
    #10 check_result(a, b, expected_result, result);

    // Test Case 2: -1.5 + 1.5 = 0
    a = 16'b1_01111_1000000000;        // -1.5
    b = 16'b0_01111_1000000000;        // 1.5
    expected_result = 16'b0000000000000000; // 0
    #10 check_result(a, b, expected_result, result);

    // Test Case 3: 0 + 3.0 = 3.0
    a = 16'b0000000000000000;          // 0
    b = 16'b0_10000_1000000000;        // 3.0
    expected_result = b;
    #10 check_result(a, b, expected_result, result);

    // Test Case 4: 5.5 + (-2.5) = 3.0
    a = 16'b0_10001_0110000000;        // 5.5
    b = 16'b1_10000_0100000000;        // -2.5
    expected_result = 16'b0_10000_1000000000; // 3.0
    #10 check_result(a, b, expected_result, result);

    // Test Case 5: 0.015625 + 0.015625 = 0.03125
    a = 16'b0_01010_0000000000; // fabricated 0.015625
    b = 16'b0_01010_0000000000;
    expected_result = 16'b0_01011_0000000000; // fabricated 0.03125
    #10 check_result(a, b, expected_result, result);

    $finish;
  end

endmodule
