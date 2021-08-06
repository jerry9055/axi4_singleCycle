
`include "common.v"

module ALU_in2_mux (
    input       [`REG_BUS]      reg_read2,
    input       [`REG_BUS]      simm,
    input       [`ALU_IN2_BUS]  sel,

	output  reg [`REG_BUS]      ALU_in2      
);

    always @(*) begin
        case(sel)
            `ALU_IN2_SIMM:  ALU_in2 = simm;
            `ALU_IN2_4:     ALU_in2 = 64'd4;
            `ALU_IN2_REG:   ALU_in2 = reg_read2;
            default:        ALU_in2 = reg_read2;
        endcase
    end

endmodule
