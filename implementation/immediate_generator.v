module immediate_generator(
	input wire [15:0] in_instruction,
	input in_clk,
	input wire in_rst,
	output reg [15:0] ot_immediate_output
);

always @(*) begin
	case (in_instruction[5:0])
		6'b001110	:	ot_immediate_output = { {5{in_instruction[15]}}, in_instruction[15:6], 1'b0 }; // jmp
		6'b001101	:	ot_immediate_output = { {5{in_instruction[15]}}, in_instruction[15:6], 1'b0 }; // jz
		6'b010011	:	ot_immediate_output = { {5{in_instruction[15]}}, in_instruction[15:6], 1'b0 }; // jnz
		default	   :	ot_immediate_output = { {6{in_instruction[15]}}, in_instruction[15:6] };
	endcase
end

endmodule