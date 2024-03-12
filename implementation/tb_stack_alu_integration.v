module tb_stack_alu_integration();

    reg rst;
    reg clk;
    reg [15:0] in_val;
    reg [3:0] stackAction;
    reg [2:0] aluCode;
    wire [15:0] top;
    wire [15:0] next;
    wire [15:0] aluResult;

    // Instantiate the stack_alu_integration module
    stack_alu_integration stack_alu (
        .rst(rst),
        .clk(clk),
        .in_val(in_val),
        .stackAction(stackAction),
        .aluCode(aluCode),
        .top(top),
        .next(next),
        .aluResult(aluResult)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Testbench stimulus
    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;

        // Push 10 onto the stack
        in_val = 16'h000A;
        stackAction = 4'b1000;
        #10;

        // Push 5 onto the stack
        in_val = 16'h0005;
        stackAction = 4'b1000;
        #10;

        // Perform ALU operation: Add top two stack elements
        stackAction = 4'b0000; // No stack action
        aluCode = 3'b000; // Add operation
        #10;

        // Check ALU result
        if (aluResult === 16'h000F) begin
            $display("Test Passed: 10 + 5 = 15");
        end else begin
            $display("Test Failed: 10 + 5 != 15");
        end

        // Pop the stack
        stackAction = 4'b0001; // Pop
        #10;

        // End simulation
        $finish;
    end
endmodule
