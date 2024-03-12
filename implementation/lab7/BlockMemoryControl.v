module RISC_V_control_unit (
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegDst,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    input Opcode,
    input CLK,
    input Reset
);

always @ (posedge CLK) begin
    $display("The opcode is %d ", Opcode);
    case (Opcode)
        7'b0110011: begin
            $display("R-type");
            ALUSrc = 0;
            MemtoReg = 0;
            RegDst = 1;
            RegWrite = 1; 
            MemRead = 0;
            MemWrite = 0; 
            Branch = 0;
        end
        7'b0000011: begin
            $display("LW");
            ALUSrc = 1;
            MemtoReg = 1;
            RegDst = 0;
            RegWrite = 1; 
            MemRead = 1;
            MemWrite = 0; 
            Branch = 0;
        end
        7'b0100011: begin
            $display("SW");
            ALUSrc = 1;
            MemtoReg = 0;
            RegDst = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
        end
        7'b1100011: begin
            $display("BEQ");
            ALUSrc = 0;
            MemtoReg = 0;
            RegDst = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
        end
        default: begin
            $display("Wrong Opcode %d ", Opcode);
        end
    endcase
end

endmodule