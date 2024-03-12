module connected_control_memory (
    input CLK,
    input [31:0] PC,
    input [31:0] datain,
    output ALUSrc,
    output MemtoReg,
    output RegDst,
    output RegWrite,
    output MemRead,
    output MemWrite,
    output Branch
);

    wire [6:0] Opcode;

    single_port_ram #(
        .DATA_WIDTH(16),
        .ADDR_WIDTH(10)
    ) memory_inst (
        .data(datain),
        .addr(PC),
        .we(0),
        .clk(CLK),
        .q(Opcode)
    );

    RISC_V_control_unit control_unit_inst (
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Opcode(Opcode),
        .CLK(CLK),
        .Reset(0)
    );

endmodule