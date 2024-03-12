module register_component (
    input wire [15:0] in_input_value,
    input wire in_clk,
    input wire in_reset,
    output reg [15:0] ot_output
);

// Register update logic
always @(posedge in_clk) begin
    if (in_reset) begin
        ot_output <= 16'h0; // Reset the register if the reset signal is high
    end else begin
        ot_output <= in_input_value; // Update the register with the input value on the rising clock edge
    end
end

endmodule
