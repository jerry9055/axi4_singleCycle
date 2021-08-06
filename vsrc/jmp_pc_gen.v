
`include "common.v"

module jmp_pc_gen (
    input       [`REG_BUS]          pc,
    input       [`REG_BUS]          simm,
    input       [`REG_BUS]          r1_data,
    input       [`BRANCH_TYPE_BUS]  branch,
    input       [`REG_BUS]          ALU_out,

    output  reg [`REG_BUS]          jmp_pc
);

    always_latch @(*) begin
        case(branch)
            `BRANCH_JAL:    jmp_pc = pc + simm;
            `BRANCH_JALR:   jmp_pc = (r1_data + simm) & ~1;
            `BRANCH_BEQ:    jmp_pc = ALU_out == `ZERO_WORD  ? pc + simm : pc + 4;
            `BRANCH_BNE:    jmp_pc = ALU_out != `ZERO_WORD  ? pc + simm : pc + 4;
            `BRANCH_BGE:    jmp_pc = $signed(ALU_out) >= 0  ? pc + simm : pc + 4;
            `BRANCH_BLT:    jmp_pc = $signed(ALU_out) <  0  ? pc + simm : pc + 4;
            `BRANCH_BGEU:   jmp_pc = ALU_out == `TRUE_64    ? pc + simm : pc + 4;
            `BRANCH_BLTU:   jmp_pc = ALU_out == `TRUE_64    ? pc + simm : pc + 4;
            `BRANCH_NULL:;
            default:;
        endcase
    end

endmodule
