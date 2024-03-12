`timescale 1ns / 1ps

module tb_register_component();
    reg [15:0] tb_input_value;
    reg tb_clk;
    reg tb_reset;
    wire [15:0] tb_output;

    // Instantiate the register_component
    register_component uut (
        .in_input_value(tb_input_value),
        .in_clk(tb_clk),
        .in_reset(tb_reset),
        .ot_output(tb_output)
    );

    // Clock generation
    always begin
        #5 tb_clk = ~tb_clk;
    end

    // Testbench stimulus
    initial begin
        tb_clk = 0;
        tb_reset = 1;
        tb_input_value = 0;
        #10;
        tb_reset = 0;
        #10;
        tb_input_value = 16'hABCD;
        #10;
        tb_input_value = 16'h1234;
        #10;
        tb_reset = 1;
        #10;
        tb_reset = 0;
        #10;
        tb_input_value = 16'h5678;
        #10;
        tb_input_value = 16'hCDEF;
        #50;
        $finish;
    end

    // Display output
    initial begin
        $monitor("Time: %t | input_value: %h | reset: %b | output: %h", $time, tb_input_value, tb_reset, tb_output);
    end

endmodule
