`timescale 1ns / 1ps

module tb_immediate_generator();
	reg [15:0] tb_instruction;
	reg tb_clk;
	reg tb_reset;
	wire [15:0] tb_output;
	
	immediate_generator uut (
		.in_instruction(tb_instruction),
		.in_clk(tb_clk),
		.in_rst(tb_reset),
		.ot_immediate_output(tb_output)
	);
	
	always begin
		#5 tb_clk = ~tb_clk;
	end
	
	initial begin
		tb_clk = 0;
      tb_reset = 1;
		tb_instruction = 16'b0000000000000000;
		#10
      tb_instruction = 16'b0000000010000010; // push c (address 10)
		#10;
		tb_instruction = 16'b0000000000000111; // add
		#10;
		tb_instruction = 16'b0000001000010011; // jnz address 1000
		#10;
		tb_instruction = 16'b1111110100001110; // jump backwards, should get neg.
		#10;
		$finish;
	end
	
	// Display output
    initial begin
        $monitor("Time: %t | input_value: %h | reset: %b | output: %h", $time, tb_instruction, tb_reset, tb_output);
    end
endmodule