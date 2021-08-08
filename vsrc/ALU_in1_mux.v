
`include "common.v"

module ALU_in1_mux (
    input       [`REG_BUS]  reg_read1,
    input       [`REG_BUS]  pc,
    input                   sel,

	output  reg [`REG_BUS]  ALU_in1      
);

    always @(*) begin
        case(sel)
            `ALU_IN1_REG:   ALU_in1 = reg_read1;
            `ALU_IN1_PC:    ALU_in1 = pc;
            default:        ALU_in1 = reg_read1;
        endcase
    end

endmodule
