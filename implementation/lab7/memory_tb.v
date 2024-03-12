module memory_tb;
        reg [9:0] addr;
        reg [15:0] in;
        wire [15:0] out;
        reg we;
        reg clk;

        memory UUT (.addr(addr), .data(in), .we(we), .clk(clk), .q(out));

        parameter HALF_PERIOD=50;
        parameter PERIOD = HALF_PERIOD * 2;

        initial begin
        clk = 0;
        forever begin
            #(HALF_PERIOD);
            clk = ~clk;
        end
        end

        initial begin
                clk = 0;
                addr = 'h000;
					  in = 'hbeef;

                #PERIOD;

                addr = 'h001;

        end
endmodule