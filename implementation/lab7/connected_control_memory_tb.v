module connected_control_memory_tb;

    reg CLK;
    reg [31:0] PC;
    reg [31:0] datain;

    wire ALUSrc;
    wire MemtoReg;
    wire RegDst;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;

    connected_control_memory dut (
        .CLK(CLK),
        .PC(PC),
        .datain(datain),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch)
    );

    parameter HALF_PERIOD = 5;
    always #HALF_PERIOD CLK <= ~CLK;

    initial begin
        CLK = 0;
        PC = 0;
        datain = 0;
    end

    initial begin
        #10;
        PC = 32'h0000_1000;
        datain = 16'h1234;
        #10;
        $display("For PC = %h, ALUSrc = %b, MemtoReg = %b, RegDst = %b, RegWrite = %b, MemRead = %b, MemWrite = %b, Branch = %b", PC, ALUSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch);
    end

    initial begin
        #10;
        PC = 32'h0000_2000;
        datain = 16'h5678;
        #10;
        $display("For PC = %h, ALUSrc = %b, MemtoReg = %b, RegDst = %b, RegWrite = %b, MemRead = %b, MemWrite = %b, Branch = %b", PC, ALUSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch);
    end
    initial #100 $finish;

endmodule
