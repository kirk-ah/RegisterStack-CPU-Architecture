module alu(
    input [15:0] operand1,
    input [15:0] operand2,
    input [2:0] code,
    output reg [15:0] result
);

always @ (operand1 or operand2 or code) begin
    case (code)
        3'b000: result <= operand1 + operand2; // Add
        3'b001: result <= operand1 - operand2; // Subtract
        3'b010: result <= operand1 & operand2; // Bitwise AND
        3'b011: result <= operand1 | operand2; // Bitwise OR
        3'b100: result <= operand1 ^ operand2; // Bitwise XOR
        3'b101: result <= operand1 << operand2; // Shift Left
        3'b110: result <= operand1 >> operand2; // Shift Right
        default: result <= 4'b0; // Default to 0
    endcase
end

endmodule
