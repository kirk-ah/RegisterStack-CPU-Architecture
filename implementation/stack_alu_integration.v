module stack_alu_integration(
    input rst,
    input clk,
    input [15:0] in_val,
    input [3:0] stackAction,
    input [2:0] aluCode,
    output [15:0] top,
    output [15:0] next,
    output [15:0] aluResult
);

    wire [15:0] stackTop;
    wire [15:0] stackNext;

    // Instantiate stack module
    stack data_stack (
        .rst(rst),
        .clk(clk),
        .in_val(in_val),
        .stackAction(stackAction),
        .top(stackTop),
        .next(stackNext)
    );

    // Instantiate ALU module
    alu alu_instance (
        .operand1(stackTop),
        .operand2(stackNext),
        .code(aluCode),
        .result(aluResult)
    );

    // Connect outputs
    assign top = stackTop;
    assign next = stackNext;

endmodule
