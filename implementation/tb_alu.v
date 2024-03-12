module tb_alu();

  reg [2:0] op_code;
  reg [15:0] operand_a;
  reg [15:0] operand_b;

  reg [15:0] expected_output;
  //wire carry_out;

  // Instantiate the ALU
  alu test_alu(.code(op_code), .operand1(operand_a), .operand2(operand_b), .result(expected_output));

  // Test case 1 - addition
  initial begin
    op_code = 3'b000;
    operand_a = 8'h05;
    operand_b = 8'h03;
    #1;
    if (expected_output !== 8'h08) begin
      $display("Test case: 1 failed");
    end else begin
      $display("Test case: 1 passed");
    end
  end

  // Test case 2 - subtraction
  initial begin
    op_code = 3'b000;
    operand_a = 8'h05;
    operand_b = 8'h03;
    #1;
    if (expected_output !== 8'h02) begin
      $display("Test case: 2 failed");
    end else begin
      $display("Test case: 2 passed");
    end
  end

  // Test case 3 - bitwise AND
  initial begin
    op_code = 3'b010;
    operand_a = 8'h0F;
    operand_b = 8'h3C;
    #1;
    if (expected_output !== 8'h0C) begin
      $display("Test case: 3 failed");
    end else begin
      $display("Test case: 3 passed");
    end
  end

  // Test case 4 - bitwise OR
  initial begin
    op_code = 3'b011;
    operand_a = 8'h0F;
    operand_b = 8'h3C;
    #1;
    if (expected_output !== 8'h3F) begin
      $display("Test case: 3 failed");
    end else begin
      $display("Test case: 3 passed");
    end
  end

endmodule
