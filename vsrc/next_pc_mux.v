
`include "common.v"

module next_pc_mux (
    input       [`REG_BUS]          seq_pc,
    input       [`REG_BUS]          jmp_pc,
    input       [`BRANCH_TYPE_BUS]  branch,

    output  reg [`REG_BUS]          next_pc
);
    assign next_pc = branch != `BRANCH_NULL ? jmp_pc : seq_pc;
endmodule
